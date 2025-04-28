{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "sstk_cronjob.app_name" }}
{{- .Release.Name | splitList "" | reverse | join "" | trunc 63 | splitList "" | reverse | join "" | trimAll "-" }}
{{- end }}

{{/*
    The base chart to use a label on the Kubernetes resources
*/}}
{{- define "base_chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | trunc 63 | replace "_" "-" | replace "+" "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
Cronjob name is limited to 53 chars. We need to make sure it's unique so we'll append the hash of the original name to the end.
*/}}
{{- define "sstk_cronjob.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- $full_name := printf "%s-%s" .Release.Name $name -}}
{{- $full_name_hash := $full_name | sha256sum | trunc 8 -}}
{{- $truncated_name := $full_name | splitList "" | reverse | join "" | trunc 43 | splitList "" | reverse | join "" | trimAll "-" -}}
{{- printf "%s-%s" $truncated_name $full_name_hash -}}
{{- end -}}


{{- define "sstk_cronjob.business_annotations" -}}
{{-   if .Values.global.meta }}
{{-     if .Values.global.meta.slackChannel }}
shutterstock.com/slack-channel: {{ .Values.global.meta.slackChannel | quote }}
{{-     end }}
{{-   end }}
{{- end -}}

{{- define "sstk_cronjob.business_labels" }}
app.kubernetes.io/name: {{ default .Release.Name .Values.appNameOverride | trunc 63 | trimAll "-"  }}
app.kubernetes.io/version: "{{ .Chart.Version }}"
{{-   if .Values.global.meta }}
{{-     if .Values.global.meta.team }}
team: {{ .Values.global.meta.team | quote }}
{{-     end }}
{{-     if .Values.global.meta.costCenter }}
costCenter: {{ .Values.global.meta.costCenter | quote }}
{{-     end }}
{{-     if .Values.global.meta.businessUnits }}
businessUnits: {{ .Values.global.meta.businessUnits | quote }}
{{-     end }}
{{-     if .Values.global.meta.valueStream }}
valueStream: {{ .Values.global.meta.valueStream | quote }}
{{-     end }}
{{-     if .Values.global.meta.owner }}
owner: {{ .Values.global.meta.owner | quote }}
{{-     end }}
{{-     if .Values.global.meta.compliance }}
security: {{ .Values.global.meta.compliance | quote }}
{{-     end }}
{{-     if .Values.global.meta.partOf }}
app.kubernetes.io/part-of: {{ .Values.global.meta.partOf | quote }}
{{-     end }}
environment: {{ .Values.global.meta.environment | quote }} # The pipeline should be injecting this
{{-   end -}}
{{- end -}}

{{- define "sstk_cronjob.base_role" }}
{{-   if $.Values.global.envValues }}
"eks.amazonaws.com/role-arn": "arn:aws:iam::{{ $.Values.global.envValues.accountId }}:role/{{ $.Values.global.envValues.roleName }}"
{{-   else }}
{{-     if eq $.Values.global.meta.environment "dev" }}
"eks.amazonaws.com/role-arn" : "arn:aws:iam::118033459220:role/base-devops-janitor-dev"
{{-     else if eq $.Values.global.meta.environment "qa" }}
"eks.amazonaws.com/role-arn" : "arn:aws:iam::706957196015:role/base-devops-janitor-qa"
{{-     else if eq $.Values.global.meta.environment "prod" }}
"eks.amazonaws.com/role-arn" : "arn:aws:iam::711314306963:role/base-devops-janitor-prod"
{{-     else if eq $.Values.global.meta.environment "ops" }}
"eks.amazonaws.com/role-arn" : "arn:aws:iam::564032534737:role/base-devops-janitor-ops"
{{-     end }}
{{-   end }}
{{- end }}