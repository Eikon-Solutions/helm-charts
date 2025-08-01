{{/*
PersistentVolumeClaim template
*/}}
{{- define "common.pvc" -}}
{{- if .Values.persistentVolume.enabled -}}
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ include "common.fullname" . }}-storage
  labels:
    {{- include "common.labels" . | nindent 4 }}
    {{- if .Values.persistentVolume.labels }}
    {{- toYaml .Values.persistentVolume.labels | nindent 4 }}
    {{- end }}
  {{- if .Values.persistentVolume.annotations }}
  annotations:
    {{- toYaml .Values.persistentVolume.annotations | nindent 4 }}
  {{- end }}
spec:
  accessModes:
    {{- range .Values.persistentVolume.accessModes }}
    - {{ . }}
    {{- end }}
  resources:
    requests:
      storage: {{ .Values.persistentVolume.size }}
  {{- if .Values.persistentVolume.storageClass }}
  {{- if (eq "-" .Values.persistentVolume.storageClass) }}
  storageClassName: ""
  {{- else }}
  storageClassName: {{ .Values.persistentVolume.storageClass }}
  {{- end }}
  {{- end }}
{{- end }}
{{- end }}