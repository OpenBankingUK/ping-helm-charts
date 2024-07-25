# Ping Identity DevOps Helm Charts

This repository contains the Ping Identity Helm charts used for deploying Ping Identity products with Helm.

The complete collection of documentation for our Helm charts and other resources is located [here](https://helm.pingidentity.com).

See [Ping Identity's DevOps Page](https://devops.pingidentity.com) for additional resources.

# OB's Customization

This is fork of the official https://github.com/pingidentity/helm-charts repository that contain OB specific customizations.

## Branches

Please follow this rules when dealing with this repository:
1. All of the OB changes should be contained to the `ob` branch. Do not make changes to the `master` branch
1. Whenever you whish update helm chart with upstream changes from official Ping repo, please create PR (make sure that you enable compare across forks) from pingidentity/helm-charts:master to OpenBankingUK/ping-helm-charts:master. This PR should not need review, because our master branch should contain only commits from Ping repo.
1. If you which merge upstream changes with OB's customizations, just PR master branch to ob branch, but be extra carefull during review to make sure that Ping changes do not conflict with OB changes

## Versioning

To maintain different helm chart versions across environements, pleas create releases/tags that could be referenced in https://github.com/OpenBankingUK/iam-config in pingdirectory configuration (HELM_CHART_VERSION variable). MAke sure that tag contain the version of the Ping upstream release (i.e. 0.9.11) and version of the OB change on top of that release and 'ob' suffix. For example first OB version of Ping's 0.9.11 release should be tagged: v0.9.11.0-ob