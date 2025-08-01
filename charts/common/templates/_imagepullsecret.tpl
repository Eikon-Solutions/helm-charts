{{/*
ImagePullSecret for private Docker registries
*/}}
{{- define "common.imagePullSecret" -}}
{{- if and .Values.dockerconfigjson.username .Values.dockerconfigjson.password -}}
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Values.dockerconfigjson.name | default (printf "%s-registry" (include "common.fullname" .)) }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: {{ printf `{"auths":{%q:{"username":%q,"password":%q,"email":%q,"auth":%q}}}` .Values.dockerconfigjson.server .Values.dockerconfigjson.username .Values.dockerconfigjson.password .Values.dockerconfigjson.email (printf "%s:%s" .Values.dockerconfigjson.username .Values.dockerconfigjson.password | b64enc) | b64enc }}
{{- end }}
{{- end }}