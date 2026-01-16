# MongoDB Helm Chart

A Helm chart for deploying MongoDB Community ReplicaSet via the MongoDB Kubernetes Operator.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- MongoDB Kubernetes Operator installed in the cluster

## Installing the Chart

To install the chart with the release name `mongodb`:

```bash
helm repo add barravar https://barravar.github.io/helm-charts
helm install mongodb barravar/mongodb -n mongodb --create-namespace
```

## Uninstalling the Chart

To uninstall/delete the `mongodb` deployment:

```bash
helm uninstall mongodb -n mongodb
```

## Values

### Common Settings

| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| `fullNameOverride` | string | Fully override the names of resources | `""` |
| `nameOverride` | string | Partially override the names of resources | `""` |
| `namespaceOverride` | string | Override resources namespace | `""` |
| `clusterDomain` | string | Default Kubernetes cluster domain | `cluster.local` |
| `commonAnnotations` | object | Common annotations to be added to all deployed resources | `{}` |
| `commonLabels` | object | Common labels to be added to all deployed resources | `{}` |
| `rbac.create` | bool | Create RBAC resources for MongoDB | `true` |
| `serviceAccount.annotations` | object | Annotations for the ServiceAccount | `{}` |
| `serviceAccount.create` | bool | Create a ServiceAccount for MongoDB | `true` |
| `serviceAccount.name` | string | Name of the ServiceAccount to use | `""` |
| `extraVolumes` | list | Extra volumes for the MongoDB pods | `[]` |
| `initContainers` | list | Additional init containers | `[]` |
| `podSecurityContext` | object | Pod Security Context | `{}` |
| `affinity` | object | Affinity rules for the MongoDB pods | `{}` |
| `nodeSelector` | object | Node selector for the MongoDB pods | `{}` |
| `tolerations` | list | Tolerations for the MongoDB pods | `[]` |

### MongoDB Configuration

| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| `mongodb.auth.adminUsername` | string | Admin username | `admin` |
| `mongodb.auth.adminPassword` | string | Admin password | `""` |
| `mongodb.auth.existingSecret` | object | Use existing secret for admin credentials | `{}` |
| `mongodb.auth.enableX509` | bool | If X.509 authentication mode should be enabled | `false` |
| `mongodb.automationConfig` | object | Additional settings for the MongoDB automation config | `{}` |
| `mongodb.config` | object | Additional MongoDB configuration | `{}` |
| `mongodb.connectionStringOptions` | object | Additional connection string options | `{}` |
| `mongodb.externalAccess` | object | Enable external access to the MongoDB Replica Set | `{}` |
| `mongodb.extraEnvVars` | list | Extra environment variables for the MongoDB container | `[]` |
| `mongodb.extraVolumeMounts` | list | Extra volume mounts for the MongoDB container | `[]` |
| `mongodb.replicaset.members` | int | Number of members in the Replica Set | `1` |
| `mongodb.replicaset.arbiters` | int | Number of arbiters to add to the Replica Set | `0` |
| `mongodb.replicaset.memberConfig` | list | Configuration for each member of the Replica Set | `[]` |
| `mongodb.roles` | list | Additional MongoDB roles to create | `[]` |
| `mongodb.users` | list | Additional MongoDB users to create | `[]` |
| `mongodb.resources` | object | Resource requests and limits for MongoDB container | `{}` |
| `mongodb.securityContext` | object | Security context for MongoDB container | `{}` |
| `mongodb.tls.enabled` | bool | Enable TLS for MongoDB servers | `false` |
| `mongodb.tls.mode` | string | TLS mode for client connections (optional, required) | `optional` |
| `mongodb.tls.caCertificateSecret` | string | Existing secret containing CA certificate | `""` |
| `mongodb.tls.certificateSecret` | string | Existing secret containing TLS certificate and key | `""` |
| `mongodb.tls.certManager.enabled` | bool | Use cert-manager integration | `false` |
| `mongodb.tls.certManager.dnsNames` | list | Extra DNS names to be included in the certificates | `[]` |
| `mongodb.tls.certManager.duration` | string | Duration for the generated certificates | `240h0m0s` |
| `mongodb.tls.certManager.renewBefore` | string | Time before expiration to renew the certificates | `48h0m0s` |

### MongoDB Agent

| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| `agent.config` | object | MongoDB Automation Agent configuration | `{}` |
| `agent.extraEnvVars` | list | Extra environment variables for the MongoDB Agent container | `[]` |
| `agent.extraVolumeMounts` | list | Extra volume mounts for the MongoDB Agent container | `[]` |
| `agent.resources` | object | Resource requests and limits for MongoDB Agent containers | `{}` |
| `agent.securityContext` | object | Security context for MongoDB Agent container | `{}` |

### Persistence

| Parameter | Type | Description | Default Value |
|-----------|------|-------------|---------------|
| `persistence.accessModes` | list | Access modes for the Persistent Volume | `""` |
| `persistence.size.data` | string | Storage request size for MongoDB data volume | `""` |
| `persistence.size.logs` | string | Storage request size for MongoDB logs volume | `""` |
| `persistence.retentionPolicy` | string | Persistent Volume retention policy (Retain, Delete) | `""` |
| `persistence.storageClass` | string | Storage Class to use for MongoDB data volume | `""` |

## Examples

### Basic Installation

Deploy a single-node MongoDB instance:

```bash
helm install mongodb barravar/mongodb -n mongodb --create-namespace \
  --set mongodb.auth.adminPassword=mySecurePassword
```

### Replica Set with 3 Members

Deploy a MongoDB Replica Set with 3 members:

```bash
helm install mongodb barravar/mongodb -n mongodb --create-namespace \
  --set mongodb.replicaset.members=3 \
  --set mongodb.auth.adminPassword=mySecurePassword \
  --set persistence.size.data=8Gi
```

### Enable TLS with cert-manager

Deploy MongoDB with TLS enabled using cert-manager:

```bash
helm install mongodb barravar/mongodb -n mongodb --create-namespace \
  --set mongodb.auth.adminPassword=mySecurePassword \
  --set mongodb.tls.enabled=true \
  --set mongodb.tls.mode=optional \
  --set mongodb.tls.certManager.enabled=true
```

### Create Additional Users

Deploy MongoDB with additional users:

```yaml
# values-custom.yaml
mongodb:
  auth:
    adminPassword: mySecurePassword
  users:
    - name: app-user
      passwordSecretRef:
        name: app-user-secret
        key: password
      roles:
        - db: myapp
          name: readWrite
    - name: readonly-user
      passwordSecretRef:
        name: readonly-user-secret
        key: password
      roles:
        - db: myapp
          name: read
```

```bash
helm install mongodb barravar/mongodb -n mongodb --create-namespace -f values-custom.yaml
```

### Custom MongoDB Configuration

Deploy MongoDB with custom configuration:

```yaml
# values-custom.yaml
mongodb:
  auth:
    adminPassword: mySecurePassword
  config:
    storage:
      wiredTiger:
        engineConfig:
          journalCompressor: zlib
    net:
      maxIncomingConnections: 1000
    operationProfiling:
      mode: slowOp
      slowOpThresholdMs: 100
```

```bash
helm install mongodb barravar/mongodb -n mongodb --create-namespace -f values-custom.yaml
```

## Connecting to MongoDB

After installation, get the MongoDB connection URI. For example, for a release named `mongodb` in the `mongodb` namespace:

```bash
kubectl get mdbc mongodb -n mongodb -o jsonpath='{.status.mongoUri}'
```

The output is the connection string to be used, for example:

```
mongodb://mongodb-0.mongodb-svc.mongodb.svc.cluster.local:27017/?replicaSet=mongodb
```

Note that, after connecting, some commands may require authentication.

## Notes

- The MongoDB Kubernetes Operator must be installed before deploying this chart
- For production deployments, it is recommended to:
  - Use at least 3 replica set members
  - Enable persistence with appropriate storage classes
  - Configure resource requests and limits
  - Enable TLS for secure communication
  - Use Kubernetes Secrets for storing passwords
  - Configure proper backup and monitoring solutions

## References

- [MongoDB Kubernetes Operator Documentation](https://github.com/mongodb/mongodb-kubernetes)
- [MongoDB Documentation](https://www.mongodb.com/docs/)
- [MongoDB Replica Set Configuration](https://www.mongodb.com/docs/manual/replication/)
- [MongoDB Security Documentation](https://www.mongodb.com/docs/manual/security/)
