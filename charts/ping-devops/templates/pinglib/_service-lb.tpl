{{- define "pinglib.service-lb.tpl" -}}
{{- $top := index . 0 -}}
{{- $v := index . 1 -}}
apiVersion: v1
kind: Service
metadata:
  {{ include "pinglib.metadata.labels" .  | nindent 2  }}
  {{ include "pinglib.metadata.annotations" .  | nindent 2  }}
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: ip
{{- if $v.services.lbExternalDNSHostname }}
    external-dns.alpha.kubernetes.io/hostname: {{ $v.services.lbExternalDNSHostname }}
{{- end }}
  name: {{ include "pinglib.fullname" . }}-lb
spec:
  type: LoadBalancer
  ports:
  {{- range $serviceName, $val := $v.services }}
  {{- if kindIs "map" $val }}
  {{- if $val.dataService }}
    - name: {{ $serviceName }}
      port: {{ $val.servicePort }}
      targetPort: {{ default $val.servicePort $val.containerPort }}
      protocol: {{ default "TCP" $val.protocol }}
  {{- end }}
  {{- end }}
  {{- end }}
  loadBalancerClass: service.k8s.aws/nlb
  selector:
    {{ include "pinglib.selector.labels" . | nindent 4 }}
{{- end -}}


{{- define "pinglib.service-lb" -}}
  {{- include "pinglib.merge.templates" (append . "service-lb") -}}
{{- end -}}
