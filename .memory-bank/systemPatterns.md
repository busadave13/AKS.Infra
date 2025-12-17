# System Patterns

## Architecture Overview

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

## Key Technical Decisions

### 1. Terraform Module Structure
```
terraform/
├── environments/     # Environment-specific configurations
│   └── dev/         # Dev environment
├── modules/         # Reusable infrastructure modules
│   ├── aks/         # AKS cluster configuration
│   ├── acr/         # Container registry
│   ├── monitoring/  # Log Analytics
│   └── networking/  # VNet and subnets
└── shared/          # Shared configurations
```

**Rationale**: Modular design enables reuse across environments (dev/staging/prod) while maintaining DRY principles.

### 2. Network Configuration
- **Plugin**: Azure CNI Overlay
- **Pod CIDR**: 10.244.0.0/16
- **Service CIDR**: 10.0.0.0/16
- **VNet CIDR**: 10.224.0.0/16
- **AKS Subnet**: 10.224.0.0/20

**Rationale**: CNI Overlay provides better IP address management without consuming VNet IPs for pods.

### 3. Node Pool Strategy
- **System Pool**: Dedicated for system pods (CriticalAddonsOnly taint)
- **User Pool**: Spot instances with autoscaling (1-2 nodes)

**Rationale**: Separating system and user workloads improves reliability; Spot instances reduce costs by 60-80%.

### 4. GitOps over Istio Add-on
- Using Flux v2 add-on instead of Istio add-on
- Istio to be deployed via GitOps

**Rationale**: More flexibility in Istio version/configuration management; consistent GitOps approach for all cluster components.

### 5. Authentication Pattern
- Azure AD (Entra ID) integration
- Azure RBAC for Kubernetes authorization
- Admin group object IDs for cluster admin access

**Rationale**: Native Azure identity integration; no separate identity management for Kubernetes.

## Design Patterns

### Infrastructure as Code
- All infrastructure defined in Terraform
- No manual Azure portal changes
- State managed via Azure Storage backend (optional)

### Environment Parity
- Same module structure for all environments
- Environment-specific values in `terraform.tfvars`
- Easy promotion from dev → staging → prod

### GitOps Workflow
- Infrastructure changes via Terraform (GitHub Actions)
- Application changes via Flux (GitRepository → Kustomization)
- Clear separation of concerns

## Component Relationships

```
terraform.tfvars
       │
       ▼
   main.tf (dev environment)
       │
       ├──► networking module ──► VNet, Subnet, NSG
       │
       ├──► acr module ──► Container Registry
       │
       ├──► monitoring module ──► Log Analytics
       │
       └──► aks module ──► AKS Cluster
                │
                ├──► System Node Pool
                ├──► User Node Pool
                ├──► Flux Extension
                └──► ACR Role Assignment
