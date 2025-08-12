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

## Using This Repository

### Adding the Repository
```bash
# Add this repository to Helm
helm repo add eikon-charts https://Eikon-Solutions.github.io/helm-charts

# Update repository index
helm repo update

# Install a chart from the repository
helm install my-app eikon-charts/web-service
```

### Available Charts
```bash
# List all available charts
helm search repo eikon-charts

# Show chart information
helm show chart eikon-charts/web-service
helm show values eikon-charts/web-service
```

## Releasing New Versions

### For Chart Maintainers

This repository uses automated releases via GitHub Actions. New chart versions are published automatically when changes are pushed to the `main` branch.

#### Release Process

1. **Update Chart Version:**
   ```bash
   # Edit charts/<chart-name>/Chart.yaml and bump the version
   # Follow semantic versioning (e.g., 0.1.0 -> 0.1.1 for patches, 0.2.0 for features)
   ```

2. **Create Release Commit:**
   ```bash
   git add charts/<chart-name>/Chart.yaml
   git commit -m "chore: bump <chart-name> to v<version>"
   git push origin main
   ```

3. **Automated Release:**
   - GitHub Actions will automatically detect the version change
   - Charts are packaged and uploaded as GitHub releases
   - The repository index (`index.yaml`) is updated
   - Charts become available via `helm repo add`

#### Manual Release (if needed)
```bash
# Build chart dependencies
helm dependency build charts/<chart-name>

# Package the chart
helm package charts/<chart-name>

# Update repository index
helm repo index . --url https://Eikon-Solutions.github.io/helm-charts

# Commit and push changes
git add index.yaml *.tgz
git commit -m "release: <chart-name> v<version>"
git push origin main
```

#### Release Checklist

- [ ] Chart version bumped in `Chart.yaml`
- [ ] Changes documented in chart README or values comments
- [ ] Chart validates with `helm lint charts/<chart-name>`
- [ ] Templates render correctly with `helm template test charts/<chart-name>`
- [ ] Dependencies updated if needed (`helm dependency update`)
- [ ] Commit follows conventional commits format

#### Version Strategy

- **Patch (0.1.0 -> 0.1.1):** Bug fixes, security updates, minor improvements
- **Minor (0.1.0 -> 0.2.0):** New features, additional configuration options
- **Major (0.1.0 -> 1.0.0):** Breaking changes, incompatible API changes

## License

See [LICENSE](LICENSE) file for details.