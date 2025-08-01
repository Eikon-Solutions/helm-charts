{{/*
ConfigMap for environment variables
*/}}
{{- define "common.configmap" -}}
{{- if or .Values.config.env .Values.configMaps -}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.fullname" . }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
data:
{{- if .Values.config.env }}
{{- range $key, $value := .Values.config.env }}
  {{ $key }}: {{ $value | quote }}
{{- end }}
{{- end }}
---
{{- end }}
{{- end }}

{{/*
ConfigMap for file mounting
*/}}
{{- define "common.configmaps" -}}
{{- range .Values.configMaps }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.fullname" $ }}-{{ .name }}
  labels:
    {{- include "common.labels" $ | nindent 4 }}
data:
{{- range .files }}
  {{ .key }}: |
{{- if .contentsB64 }}
{{ .contentsB64 | b64dec | nindent 4 }}
{{- else if .contentsFile }}
{{ $.Files.Get .contentsFile | nindent 4 }}
{{- end }}
{{- end }}
---
{{- end }}
{{- end }}