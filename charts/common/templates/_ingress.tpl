{{/*
Ingress template with support for multiple hostnames
*/}}
{{- define "common.ingress" -}}
{{- if .Values.service.ingress -}}
{{- range $name, $config := .Values.service.ingress }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "common.fullname" $ }}-{{ $name }}
  labels:
    {{- include "common.labels" $ | nindent 4 }}
  annotations:
    {{- if $config.enableTraefik | default true }}
    kubernetes.io/ingress.class: traefik
    {{- end }}
    {{- if $config.certificateCreate | default true }}
    cert-manager.io/cluster-issuer: {{ $config.certificateIssuerName | default "letsencrypt-staging" }}
    {{- end }}
    {{- if $config.annotations }}
    {{- toYaml $config.annotations | nindent 4 }}
    {{- end }}
spec:
  {{- if $config.certificateCreate | default true }}
  tls:
    - hosts:
        - {{ $config.hostname }}
      secretName: {{ $config.tlsSecretName | default (printf "%s-tls" ($config.hostname | replace "." "-")) }}
  {{- end }}
  rules:
    - host: {{ $config.hostname }}
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: {{ include "common.fullname" $ }}
                port:
                  number: {{ $.Values.service.port }}
---
{{- end }}
{{- end }}
{{- end }}