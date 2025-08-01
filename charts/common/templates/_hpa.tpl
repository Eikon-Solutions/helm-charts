{{/*
HorizontalPodAutoscaler template
*/}}
{{- define "common.hpa" -}}
{{- if .Values.hpa.deploy -}}
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ include "common.fullname" . }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ include "common.fullname" . }}
  minReplicas: {{ .Values.hpa.minReplicas | default 1 }}
  maxReplicas: {{ .Values.hpa.maxReplicas | default 10 }}
  metrics:
    {{- if .Values.hpa.metrics }}
    {{- toYaml .Values.hpa.metrics | nindent 4 }}
    {{- else }}
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 75
    {{- end }}
  {{- if .Values.hpa.behavior }}
  behavior:
    {{- toYaml .Values.hpa.behavior | nindent 4 }}
  {{- end }}
{{- end }}
{{- end }}