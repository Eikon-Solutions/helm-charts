{{/*
Secret for sensitive environment variables
*/}}
{{- define "common.secret" -}}
{{- if or .Values.config.secrets .Values.config.secretsB64 -}}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "common.fullname" . }}-secrets
  labels:
    {{- include "common.labels" . | nindent 4 }}
type: Opaque
data:
{{- if .Values.config.secrets }}
{{- range $key, $value := .Values.config.secrets }}
  {{ $key }}: {{ $value | b64enc }}
{{- end }}
{{- end }}
{{- if .Values.config.secretsB64 }}
{{- range $key, $value := .Values.config.secretsB64 }}
  {{ $key }}: {{ $value }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}