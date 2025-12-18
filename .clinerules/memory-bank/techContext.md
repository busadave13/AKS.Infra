# Technical Context: AKS.Infrastructure

## Technology Stack Details

### Terraform Configuration
- **Version**: 1.6.0+
- **Backend**: Azure Storage Account (azurerm)
- **Provider**: AzureRM 4.52.0 (pinned in root module)
- **State File**: `aks-dev.terraform.tfstate`
- **Version Management**: Centralized in `terraform/environments/dev/main.tf` (no versions.tf in modules)

### Testing Framework
- **TFLint**: v0.50.3 with Azure ruleset (static analysis)
- **Checkov**: Security scanning for Azure resources
- **Terraform Tests**: Native `.tftest.hcl` files for module validation

### Azure Resources (Development Environment)

| Resource | Name Pattern | SKU/Tier |
|----------|--------------|----------|
| Resource Group | `rg-aks-dev-wus2` | N/A |
| Node Resource Group | `rg-aks-nodepool-dev-wus2` | N/A (Azure-managed) |
| Virtual Network | `vnet-aks-dev-wus2` | 10.0.0.0/16 |
| AKS Cluster | `aks-dev-wus2` | Free tier |
| System Node Pool | `system` | Standard_B2ms (2 nodes) |
| Workload Node Pool | `workload` | Standard_B2ms (2 nodes) |
| Container Registry | `acraksdevwus2` | Basic |
| Key Vault | `kv-aks-dev-wus2` | Standard |
| Log Analytics | `log-aks-dev-wus2` | Pay-as-you-go |
| Monitor Workspace | `amw-aks-dev-wus2` | Pay-as-you-go |
| Managed Grafana | `grafana-aks-dev-wus2` | Essential |

### Network Configuration
| Subnet | CIDR | Purpose |
|--------|------|---------|
| snet-aks-nodes | 10.0.0.0/22 | AKS node pool nodes |
| snet-privateendpoints | 10.0.4.0/24 | Private endpoints |
| Pod Network (Overlay) | 10.244.0.0/16 | Kubernetes pods |
| Service Network | 10.245.0.0/16 | Kubernetes services |

### AKS Configuration
- **Kubernetes Version**: 1.32.x (latest stable)
- **Network Plugin**: Azure CNI Overlay
- **Network Policy**: Azure
- **Availability Zones**: 1, 2, 3
- **OIDC Issuer**: Enabled
- **Workload Identity**: Enabled
- **CSI Secrets Store Driver**: Enabled

### Terraform Modules

| Module | Purpose | Key Resources |
|--------|---------|---------------|
| `networking` | VNet, Subnets, NSG | Virtual network infrastructure |
| `aks` | AKS cluster, Node pools | Kubernetes cluster |
| `acr` | Container Registry | Image storage |
| `keyvault` | Key Vault | Secrets management |
| `monitoring` | Log Analytics, Prometheus, Grafana | Observability stack |
| `gitops` | Flux extension, Configurations | GitOps deployment |

### GitOps Configuration
- **Tool**: Flux v2 (AKS extension)
- **Repository**: Separate repository (AKS.GitOps)
- **Sync Interval**: 60 seconds
- **Controllers Enabled**:
  - source-controller
  - kustomize-controller
  - helm-controller
  - notification-controller

### CI/CD Pipeline
- **Platform**: GitHub Actions
- **Main Workflow**: `.github/workflows/terraform.yml` - Infrastructure deployment
  - Stages: Validate → Plan → Apply/Destroy
- **Test Workflow**: `.github/workflows/terraform-test.yml` - Testing and validation
  - Stages: TFLint → Checkov → Format → Validate → Terraform Tests
- **Authentication**: OIDC (OpenID Connect) with Azure AD
- **Required Secrets**:
  - `AZURE_CLIENT_ID`
  - `AZURE_TENANT_ID`
  - `AZURE_SUBSCRIPTION_ID`

### Testing Infrastructure

#### TFLint Configuration (`terraform/.tflint.hcl`)
- Azure provider plugin enabled
- Terraform language rules (recommended preset)
- Naming convention enforcement (snake_case)
- Variable/output documentation requirements
- Standard module structure checks

#### Checkov Configuration (`terraform/.checkov.yaml`)
- Security scanning for Azure resources
- Skipped checks for dev environment:
  - CKV_AZURE_117 (disk encryption set)
  - CKV_AZURE_226 (ephemeral OS disks)
  - CKV_AZURE_141 (private cluster mode)
- HIGH/CRITICAL severity threshold
- JUnit XML output for CI integration

#### Terraform Native Tests (`terraform/tests/`)
- `networking_test.tftest.hcl` - Network module validation
- `aks_test.tftest.hcl` - AKS configuration tests
- `monitoring_test.tftest.hcl` - Monitoring module tests
- `integration_test.tftest.hcl` - Full environment validation

## Development Dependencies
- Azure CLI
- Terraform CLI (1.6.0+)
- TFLint (0.50.3+)
- Checkov (latest)
- kubectl
- Helm (optional)
- Git

## Important File Locations
| File | Purpose |
|------|---------|
| `.docs/architecture-design.md` | Complete architecture documentation |
| `terraform/environments/dev/main.tf` | Root module for dev environment |
| `terraform/environments/dev/variables.tf` | Variable definitions |
| `terraform/environments/dev/backend.tf` | State backend config |
| `.github/workflows/terraform.yml` | GitHub Actions CI/CD pipeline |
| `terraform/.tflint.hcl` | TFLint configuration |
| `terraform/.checkov.yaml` | Checkov security scan config |
| `terraform/tests/` | Terraform native test files |
