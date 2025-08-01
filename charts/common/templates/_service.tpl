{{/*
Service template
*/}}
{{- define "common.service" -}}
{{- if .Values.service.deploy -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "common.fullname" . }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
  {{- if .Values.service.annotations }}
  annotations:
    {{- toYaml .Values.service.annotations | nindent 4 }}
  {{- end }}
spec:
  type: ClusterIP
  ports:
    - port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.targetPort | default .Values.service.port }}
      protocol: {{ .Values.service.protocol | default "TCP" }}
      name: http
  selector:
    {{- include "common.selectorLabels" . | nindent 4 }}
{{- end }}
{{- end }}