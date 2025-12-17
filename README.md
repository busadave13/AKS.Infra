# AKS Infrastructure

Terraform Infrastructure as Code for Azure Kubernetes Service (AKS) dev cluster.

## Architecture Overview

This repository contains Terraform configurations for deploying a cost-optimized AKS dev cluster with the following features:

- **Region**: West US 2
- **Authentication**: Azure AD (Entra ID) with Azure RBAC
- **API Server**: Public access
- **GitOps**: Flux v2 add-on enabled for declarative deployments
- **Node Pools**: 
  - System pool: 1x Standard_B2ms (dedicated for system pods)
  - User pool: 1-2x Standard_B2ms with Spot instances for cost savings
- **Container Registry**: Azure Container Registry (Basic SKU)
- **Monitoring**: Container Insights with Log Analytics

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                     Azure Resource Group                         │
│                    rg-aks-dev-westus2                            │
│                                                                  │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                 Virtual Network                          │    │
│  │              vnet-aks-dev (10.224.0.0/16)               │    │
│  │                                                          │    │
│  │  ┌─────────────────────────────────────────────────┐    │    │
│  │  │         AKS Subnet (10.224.0.0/20)              │    │    │
│  │  │                                                  │    │    │
│  │  │  ┌─────────────────────────────────────────┐   │    │    │
│  │  │  │         AKS Cluster                      │   │    │    │
│  │  │  │        aks-dev-westus2                   │   │    │    │
│  │  │  │                                          │   │    │    │
│  │  │  │  • System Node Pool (1x B2ms)           │   │    │    │
│  │  │  │  • User Node Pool (1-2x B2ms Spot)      │   │    │    │
│  │  │  │  • GitOps (Flux v2) Add-on              │   │    │    │
│  │  │  │  • Azure CNI Overlay                     │   │    │    │
│  │  │  │  • Azure AD + Azure RBAC                │   │    │    │
│  │  │  │                                          │   │    │    │
│  │  │  └──────────────────────────────────────────┘   │    │    │
│  │  └─────────────────────────────────────────────────┘    │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                  │
│  ┌─────────────────┐    ┌─────────────────────────────┐         │
│  │ Container       │    │ Log Analytics Workspace     │         │
│  │ Registry (Basic)│    │ (Container Insights)        │         │
│  └─────────────────┘    └─────────────────────────────┘         │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

## Project Structure

```
├── .github/
│   └── workflows/
│       └── terraform.yml      # CI/CD pipeline
├── terraform/
│   ├── environments/
│   │   └── dev/
│   │       ├── main.tf        # Root module composition
│   │       ├── variables.tf   # Variable definitions
│   │       ├── outputs.tf     # Output values
│   │       ├── terraform.tfvars # Environment values
│   │       └── backend.tf     # State backend config
│   ├── modules/
│   │   ├── aks/              # AKS cluster module
│   │   ├── acr/              # Container registry module
│   │   ├── monitoring/       # Log Analytics module
│   │   └── networking/       # VNet and subnets module
│   └── shared/
│       └── versions.tf       # Provider constraints
└── README.md
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.6.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) >= 2.50.0
- Azure subscription with Owner or Contributor access
- (Optional) Azure AD group for cluster admin access

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/busadave13/AKS.Infrastructure.git
cd AKS.Infrastructure
```

### 2. Authenticate to Azure

```bash
az login
az account set --subscription "<your-subscription-id>"
```

### 3. Configure Variables

Edit `terraform/environments/dev/terraform.tfvars`:

```hcl
# Update the ACR name to be globally unique
acr_name = "acryourorgdevwestus2"

# Add your Azure AD group object IDs for cluster admin access
admin_group_object_ids = ["<your-aad-group-object-id>"]
```

### 4. Initialize and Deploy

```bash
cd terraform/environments/dev

# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply changes
terraform apply
```

### 5. Connect to the Cluster

```bash
# Get credentials
az aks get-credentials --resource-group rg-aks-dev-westus2 --name aks-aks-dev-westus2

# Verify connection
kubectl get nodes
```

## GitOps with Flux

The cluster comes with Flux v2 pre-installed. To configure a GitOps repository:

```bash
# Create a Flux GitRepository source
kubectl apply -f - <<EOF
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: my-app
  namespace: flux-system
spec:
  interval: 1m
  url: https://github.com/your-org/your-gitops-repo
  ref:
    branch: main
EOF

# Create a Kustomization to deploy from the repo
kubectl apply -f - <<EOF
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: my-app
  namespace: flux-system
spec:
  interval: 10m
  sourceRef:
    kind: GitRepository
    name: my-app
  path: ./clusters/dev
  prune: true
EOF
```

## CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/terraform.yml`) provides:

- **Format Check**: Validates Terraform formatting
- **Validate**: Syntax and configuration validation
- **Plan**: Creates execution plan on PRs (commented on PR)
- **Apply**: Deploys changes when merged to main

### Required GitHub Secrets

Configure these secrets in your GitHub repository:

| Secret | Description |
|--------|-------------|
| `AZURE_CLIENT_ID` | Service Principal App ID |
| `AZURE_CLIENT_SECRET` | Service Principal Secret |
| `AZURE_SUBSCRIPTION_ID` | Azure Subscription ID |
| `AZURE_TENANT_ID` | Azure AD Tenant ID |

### Create Service Principal

```bash
az ad sp create-for-rbac \
  --name "sp-github-aks-infrastructure" \
  --role Contributor \
  --scopes /subscriptions/<subscription-id>
```

## Estimated Monthly Cost

| Resource | Cost (Est.) |
|----------|-------------|
| AKS System Pool (1x B2ms) | ~$60 |
| AKS User Pool (1x B2ms Spot) | ~$15-20 |
| Container Registry (Basic) | ~$5 |
| Log Analytics (5GB/day free) | ~$0-10 |
| **Total** | **~$80-95/month** |

## Deploying Istio with GitOps

Since the cluster uses GitOps instead of the Istio add-on, you can deploy Istio via Flux:

1. Add the Istio Helm repository as a source
2. Create a HelmRelease for Istio base and istiod
3. Configure Istio ingress gateway

Example Flux configuration for Istio is available in the [Istio documentation](https://istio.io/latest/docs/setup/install/helm/).

## Troubleshooting

### Cannot connect to cluster

```bash
# Ensure you're logged in
az login

# Get fresh credentials
az aks get-credentials --resource-group rg-aks-dev-westus2 --name aks-aks-dev-westus2 --overwrite-existing
```

### Spot nodes not scheduling pods

Spot nodes have a taint. Add tolerations to your workloads:

```yaml
tolerations:
- key: "kubernetes.azure.com/scalesetpriority"
  operator: "Equal"
  value: "spot"
  effect: "NoSchedule"
```

### Flux not syncing

```bash
# Check Flux status
kubectl get kustomizations -A
kubectl get gitrepositories -A

# Check Flux logs
kubectl logs -n flux-system deployment/source-controller
kubectl logs -n flux-system deployment/kustomize-controller
```

## Contributing

1. Create a feature branch
2. Make changes
3. Run `terraform fmt -recursive` to format code
4. Create a pull request
5. Review the Terraform plan in PR comments
6. Merge to main to apply changes

## License

MIT
