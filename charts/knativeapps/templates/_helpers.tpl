{{/*
Expand the name of the chart.
*/}}
{{- define "knativeapps.name" }}
{{- default .Release.Name .Values.appNameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "knativeapps.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "knativeapps.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "knativeapps.labels" -}}
helm.sh/chart: {{ include "knativeapps.chart" . }}
{{ include "knativeapps.selectorLabels" . }}
{{- if .Values.appVersion }}
app.kubernetes.io/version: {{ .Values.appVersion | quote }}
{{- end }}
app.kubernetes.io/release: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* 
Selector labels 
*/}}
{{- define "knativeapps.selectorLabels" -}}
app.kubernetes.io/name: {{ include "knativeapps.name" . }}
{{- end }}

{{/*
Label to define how to expose the service
# cluster-local: service is only accessible from within the cluster
# internal: service is accessible from within our private network
# external: service is globally exposed
*/}}
{{- define "knativeapps.service_visibility" -}}
knative.barravar.dev.br/visibility: {{ .Values.kservice.visibility | default "cluster-local" }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "knativeapps.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "knativeapps.name" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Autoscaling configuration
*/}}
{{- define "knativeapps.autoScaling" }}
{{- $class := "kpa.autoscaling.knative.dev" -}}
{{- if and (ne .Values.autoscaling.metric "concurrency") (ne .Values.autoscaling.metric "rps") }}
{{- $class = "hpa.autoscaling.knative.dev" }}
{{- end }}
autoscaling.knative.dev/class: {{ $class }}
autoscaling.knative.dev/metric: {{ .Values.autoscaling.metric | quote }}
autoscaling.knative.dev/target: {{ .Values.autoscaling.target | quote }}
autoscaling.knative.dev/min-scale: {{ .Values.autoscaling.minScale | quote }}
autoscaling.knative.dev/max-scale: {{ .Values.autoscaling.maxScale | quote }}
autoscaling.knative.dev/initial-scale: {{ .Values.autoscaling.initialScale | quote }}
autoscaling.knative.dev/scale-down-delay: {{ .Values.autoscaling.scaleDownDelay | quote }}
autoscaling.knative.dev/window: {{ .Values.autoscaling.stableWindow | quote }}
{{- if eq .Values.autoscaling.metric "concurrency" }}
autoscaling.knative.dev/target-utilization-percentage: {{ .Values.autoscaling.concurrencyTargetPercentage | quote }}
{{- end }}
{{- end }}

# {{/*
# Retention (GC) configuration 
# */}}
# {{- define "knativeapps.retention" }}
# {{- with .Values.retention }}
# {{- if .sinceCreate }}
# serving.knative.dev/retain-since-create-time: {{ .sinceCreate | quote }}
# {{- end }}
# {{- if .sinceLastActive }}
# serving.knative.dev/retain-since-last-active-time: {{ .sinceLastActive | quote }}
# {{- end }}
# {{- if .minNonActive }}
# serving.knative.dev/min-non-active-revisions: {{ .minNonActive | quote }}
# {{- end }}
# {{- if .maxNonActive }}
# serving.knative.dev/max-non-active-revisions: {{ .maxNonActive | quote }}
# {{- end }}
# {{- end }}
# {{- end }}