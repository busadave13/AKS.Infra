# Technical Context

## Technologies Used

### Infrastructure as Code
| Technology | Version | Purpose |
|------------|---------|---------|
| Terraform | >= 1.6.0 | Infrastructure provisioning |
| AzureRM Provider | ~> 4.14 | Azure resource management |
| AzureAD Provider | ~> 3.0 | Azure AD integration |

### Azure Services
| Service | SKU/Tier | Purpose |
|---------|----------|---------|
| AKS | Free tier | Kubernetes cluster |
| Container Registry | Basic | Container image storage |
| Log Analytics | PerGB2018 | Monitoring and logging |
| Virtual Network | Standard | Network isolation |

### Kubernetes Components
| Component | Version | Purpose |
|-----------|---------|---------|
| Kubernetes | 1.30.x (latest) | Container orchestration |
| Flux v2 | Latest (via add-on) | GitOps operator |
| Azure CNI Overlay | Built-in | Pod networking |

### CI/CD
| Tool | Purpose |
|------|---------|
| GitHub Actions | Terraform automation |
| Terraform CLI | Plan and apply operations |

## Development Setup

### Prerequisites
```bash
# Required tools
- Terraform >= 1.6.0
- Azure CLI >= 2.50.0
- kubectl (for cluster access)
- Git

# Azure requirements
- Azure subscription with Contributor access
- Azure AD permissions for app registration (if using service principal)
```

### Local Development
```bash
# Clone repository
git clone https://github.com/busadave13/AKS.Infrastructure.git
cd AKS.Infrastructure

# Azure authentication
az login
az account set --subscription "<subscription-id>"

# Initialize Terraform
cd terraform/environments/dev
terraform init

# Plan and apply
terraform plan
terraform apply
```

### Environment Variables (CI/CD)
```bash
ARM_CLIENT_ID        # Service Principal App ID
ARM_CLIENT_SECRET    # Service Principal Secret
ARM_SUBSCRIPTION_ID  # Azure Subscription ID
ARM_TENANT_ID        # Azure AD Tenant ID
```

## Technical Constraints

### AKS Limitations
- Free tier: No SLA, limited features
- Spot nodes: Can be evicted at any time
- System node pool: Minimum 1 node required

### Network Constraints
- Pod CIDR: 10.244.0.0/16 (65,536 pod IPs)
- Service CIDR: 10.0.0.0/16 (65,536 service IPs)
- VNet CIDR: 10.224.0.0/16
- Subnet: /20 = 4,096 node IPs

### Cost Constraints
- Target: < $100/month for dev environment
- Spot instances: 60-80% discount but can be evicted
- Basic ACR: Limited features, 10GB storage

## Dependencies

### Module Dependencies
```
environments/dev/main.tf
    └── modules/networking (VNet must exist first)
    └── modules/acr (independent)
    └── modules/monitoring (independent)
    └── modules/aks (depends on all above)
```

### External Dependencies
- Azure subscription
- GitHub repository (for CI/CD)
- Azure AD tenant (for authentication)

## Configuration Files

### Key Terraform Files
| File | Purpose |
|------|---------|
| `terraform.tfvars` | Environment-specific values |
| `backend.tf` | State storage configuration |
| `main.tf` | Root module composition |
| `variables.tf` | Input variable definitions |
| `outputs.tf` | Output value definitions |

### GitHub Actions
| File | Purpose |
|------|---------|
| `.github/workflows/terraform.yml` | CI/CD pipeline |

### Documentation
| File | Purpose |
|------|---------|
| `README.md` | Project documentation |
| `.clinerules/` | AI assistant guidelines |
| `.memory-bank/` | Project context |
