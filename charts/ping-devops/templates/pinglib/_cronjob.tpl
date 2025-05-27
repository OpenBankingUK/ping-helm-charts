{{- define "pinglib.cronjob.tpl" -}}
{{- $top := index . 0 -}}
{{- $v := index . 1 }}
{{- if $v.cronjob.enabled -}}
{{- $podName := print (include "pinglib.addreleasename" (append . $v.name)) "-0" -}}
{{- $baseArgs := list "exec" "-ti" $podName "--container" "utility-sidecar" "--" -}}
{{- $args := concat $baseArgs $v.cronjob.args -}}
{{- if $top.Capabilities.APIVersions.Has "batch/v1" }}
apiVersion: batch/v1
{{- else }}
apiVersion: batch/v1beta1
{{- end }}
kind: CronJob
metadata:
  {{ include "pinglib.metadata.labels" .  | nindent 2  }}
  {{ include "pinglib.metadata.annotations" .  | nindent 2  }}
  name: {{ include "pinglib.fullname" . }}-cronjob
spec:
  {{ if $v.cronjob.spec }}
  {{ toYaml $v.cronjob.spec | nindent 2 }}
  {{ else }}
  successfulJobsHistoryLimit: 0
  failedJobsHistoryLimit: 1
  {{ end }}
  {{ if not $v.cronjob.spec.jobTemplate }}
  jobTemplate:
    spec:
      template:
        spec:
          serviceAccount: {{ include "pinglib.fullname" . }}-internal-kubectl
          restartPolicy: OnFailure
          {{- if $v.cronjob.podSecurityContext }}
          securityContext: {{ toYaml $v.cronjob.podSecurityContext | nindent 12 }}
          {{- end }}
          containers:
          - name: {{ include "pinglib.fullname" . }}-cronjob
            image: {{ $v.cronjob.image }}
            {{- if $v.cronjob.containerSecurityContext }}
            securityContext: {{ toYaml $v.cronjob.containerSecurityContext | nindent 14 }}
            {{- end }}
            command: ["kubectl"]
            args:
              {{- range $args }}
              - {{ . }}
              {{- end -}}
  {{ end }}
{{- end -}}
{{- end -}}

{{- define "pinglib.cronjob" -}}
  {{- include "pinglib.merge.templates" (append . "cronjob") -}}
{{- end -}}
