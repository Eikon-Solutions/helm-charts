# Helm Charts

Opinionated Helm charts for quick deployment of containerized applications in homelab and small-scale environments.

## Charts

### 🌐 web-service
A comprehensive Helm chart for deploying web applications with deployment, service, and ingress resources.

**Features:**
- Docker image deployment with configurable tags
- Private Docker registry support
- Environment variables and secrets management
- ConfigMap file mounting
- Health checks (readiness/liveness probes)
- Horizontal Pod Autoscaler (HPA)
- Multiple ingress hostnames with SSL certificates
- Persistent storage support
- Resource limits and requests
- Rolling update deployment strategy
- Pod annotations

**Quick Start:**
```bash
# Deploy with defaults (nginx:latest)
helm install my-app ./charts/web-service

# Deploy custom image
helm install my-app ./charts/web-service \
  --set image.repository=myapp \
  --set image.tag=v1.0.0 \
  --set service.port=8080

# Deploy with ingress
helm install my-app ./charts/web-service \
  --set service.ingress.main.hostname=myapp.example.com
```

### 📚 common (Library Chart)
Shared templates and helper functions used across all application charts to maintain DRY principles.

**Included Templates:**
- `_helpers.tpl` - Common labels, names, and utility functions
- `_configmap.tpl` - Environment variables and file mounting
- `_secret.tpl` - Sensitive data management
- `_service.tpl` - Kubernetes service
- `_ingress.tpl` - Multi-hostname ingress with cert management
- `_hpa.tpl` - Horizontal Pod Autoscaler
- `_pvc.tpl` - Persistent Volume Claims
- `_imagepullsecret.tpl` - Private registry authentication

## Usage

### Dependencies
Build chart dependencies before installation:
```bash
cd charts/web-service
helm dependency build
```

### Installation
```bash
# Install with default values
helm install release-name ./charts/web-service

# Install with custom values file
helm install release-name ./charts/web-service -f my-values.yaml

# Upgrade existing installation
helm upgrade release-name ./charts/web-service
```

### Configuration Examples

**Private Registry:**
```yaml
image:
  repository: registry.example.com/myapp
  tag: latest
dockerconfigjson:
  username: myuser
  password: mypassword
  server: https://registry.example.com
```

**Multiple Domain Ingress:**
```yaml
service:
  ingress:
    main:
      hostname: app.example.com
      certificateIssuerName: letsencrypt-prod
    api:
      hostname: api.example.com
      annotations:
        nginx.ingress.kubernetes.io/rewrite-target: /
```

**Environment Variables & Secrets:**
```yaml
config:
  env:
    DATABASE_URL: postgresql://localhost:5432/myapp
    LOG_LEVEL: info
  secrets:
    DB_PASSWORD: supersecret
    API_KEY: secret-key
```

**File Configuration:**
```yaml
configMaps:
  - name: app-config
    mountPath: /etc/config
    files:
      - key: app.conf
        contentsB64: <base64-encoded-content>
```

## License

See [LICENSE](LICENSE) file for details.