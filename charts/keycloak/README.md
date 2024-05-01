# Keycloak

[Keycloak](https://keycloak.org) is an open source Identity and Access Management that provides user federation, authentication, fine-grained authorization and management for applications.

## Description
This chart installs Keycloak using Helm package manager using in-memory database by default.

## Installing

To install the chart, run the command below. With that, a release named `keycloak` will be bootstrapped into your Kubernetes cluster.
```
helm install keycloak barravar/keycloak
```

## Uninstalling

To uninstall the chart, simply run:
```
helm delete keycloak
```

## Configuration options

Following configuration options are available. Customize it via `values.yaml` file or Helm CLI flags.
```
helm install keycloak barravar/keycloak -f values.yaml
```

| Parameter | Description | Default value |
|-----------|-------------|---------------|
| `admin` | Keycloak initial credentials. If not set, defaults for `admin.user` and `admin.password` are used. | {} |
| `admin.password` | Keycloak admin password. | random generated value |
| `admin.user` | Keycloak admin user. | "admin" |
| `admin.existingSecret` | Use an existing secret to set credentials. | {} |
| `admin.existingSecret.secretName` | Keycloak credentials secret name. | "" |
| `admin.existingSecret.userKey` | Secret key to set Keycloak admin username. | "" |
| `admin.existingSecret.passwordKey` | Secret key to set Keycloak admin password. | "" |
| `affinity` | Keycloak pod affinity config. | "" |
| `autoscaling.enabled` | Enable Keycloak pod autoscaling via `HorizontalPodAutoscaler`. | false |
| `autoscaling.minReplicas` | Minimum number of replicas. | "" |
| `autoscaling.maxReplicas` | Maximum number of replicas. | "" |
| `autoscaling.targetCPUUtilizationPercentage` | CPU utilization percentage to trigger autoscaling. | "" |
| `autoscaling.targetMemoryUtilizationPercentage` | Memory utilization percentage to trigger autoscaling. | "" |
| `certificate.enabled` | Keycloak certificate. Requires `cert-manager`. | false |
| `certificate.secretName` | Keycloak certificate secret name. Required if `certificate.enabled` is `true`. | "" |
| `certificate.domain` | Keycloak certificate domain name. Required if `certificate.enabled` is `true`. | "" |
| `certificate.issuer` | Keycloak certificate manager issuer config. Required if `certificate.enabled` is `true`. | "" |
| `clusterDomain` | The internal Kubernetes cluster domain. | cluster.local |
| `database` | Keycloak database connection. | {} |
| `database.vendor` | Keycloak database vendor. | "dev-file" |
| `database.host` | Hostname of the default JDBC URL of the chosen vendor. | "" |
| `database.port` | Port of the default JDBC URL of the chosen vendor. | "" |
| `database.database` | Database name of the default JDBC URL of the chosen vendor. | "" |
| `database.user` | Username of the default JDBC URL of the chosen vendor. | "" |
| `database.password` | Password of the default JDBC URL of the chosen vendor. | "" |
| `database.existingSecret` | Use an existing secret to set KC_DB_USERNAME and KC_DB_PASSWORD. Values required if enabled. Has precedence over `database.user` and `database.password`. | {} |
| `database.existingSecret.secretName` | Database credentials secret name. | "" |
| `database.existingSecret.userKey` | Secret key to set Database username. | "" |
| `database.existingSecret.passwordKey` | Secret key to set Database password. | "" |
| `extraEnv` | Keycloak extra environment variables. | [] |
| `extraInitContainers` | Additional init containers config. | [] |
| `health.enable` | Enable Keycloak pod health probes. | true |
| `health.startupProbe` | Keycloak pod startup probe config. | {"httpGet: {"path": "/health", "port": "http"}, "initialDelaySeconds": 30, "timeoutSeconds": 1, "failureThreshold": 60, "periodSeconds": 5} |
| `health.readinessProbe` | Keycloak pod readiness probe config. | {"httpGet": {"path": "/health/ready", "port": "http"}, "initialDelaySeconds": 30, "timeoutSeconds": 1} |
| `health.livenessProbe` | Keycloak pod liveness probe config. | {"httpGet": {"path": "/health/live", "port": "http"}, "initialDelaySeconds": 0, "timeoutSeconds": 0}
| `image.repository` | Keycloak image repository. | quay.io/keycloak/keycloak |
| `image.pullPolicy` | Keycloak image pull policy. | IfNotPresent |
| `image.tag` | Keycloak image tag. Defaults to `Chart.AppVersion`. | "" |
| `imagePullSecrets` | Image pull secrets for Keycloak pod. | [] |
| `ingress` | Keycloak ingress configuration. | {} |
| `ingress.enabled` | Enable Keycloak ingress configuration. | false |
| `ingress.className` | Ingress class name. Required if `ingress.enabled` is `true`. | "" |
| `ingress.annotations` | Ingress annotations. | {} |
| `ingress.labels` | Ingress labels. | {} |
| `ingress.rules` | Ingress rules. Required if `ingress.enabled` is `true`. | [] |
| `ingress.rules[].host` | Ingress rule FQDN host name. | "" |
| `ingress.rules[].paths` | Ingress rule path. Required if `ingress.enabled` is `true`. | [] |
| `ingress.tls` | Ingress TLS configuration. | [] |
| `fullnameOverride` | Override full qualified chart name. | "" |
| `nameOverride` | Override chart name. | "" |
| `nodeSelector` | Keycloak pod node selector config. | {} |
| `podAnnotations` | Keycloak pod annotations. | {} |
| `podSecurityContext` | SecurityContext for the Pod. | {"fsGroup": 1000} |
| `ports` | Keycloak HTTP and HTTPS ports. If not set, default HTTP port is set; HTTPS is only exposed if explicitly set. | {} |
| `ports.http` | Keycloak service HTTP port number. | 8080 |
| `ports.https` | Keycloak service HTTPS port number. | "" |
| `proxy` | Keycloak proxy headers that should be accepted by the server. Sets KC_PROXY_HEADERS environment variable. | {"enabled": true, "mode": "forwarded"} |
| `replicaCount` | Number of Keycloak pod replicas. | 1 |
| `resources` | Pod resource requests and limits. | {} |
| `securityContext` | Keycloak container security context. | {"capabilities": {"drop": ["ALL"]}, "readOnlyRootFilesystem": true, "runAsNonRoot": true, "runAsUser": 1000} |
| `service` | Keycloak service configuration. | {"type": "ClusterIP", "httpPort": 80} |
| `service.annotations` | Keycloak service annotations. | {} |
| `service.labels` | Keycloak service labels. | {} |
| `service.type` | Keycloak service type. | ClusterIP |
| `service.httpPort` | Keycloak service HTTP port. | 80 |
| `service.httpNodePort` | Keycloak service nodePort. Required if `service.type` is `NodePort`. | "" |
| `service.httpsPort` | Keycloak service HTTPS port. | "" |
| `serviceAccount.create` | Create Keycloak service account. | true |
| `serviceAccount.annotations` | Keycloak service account annotations. | {} |
| `serviceAccount.name` | Keycloak service account name. If not set and create is true, generates a name using the `fullname` template. | "" |
| `tolerations` | Keycloak pod toleration config. | [] |