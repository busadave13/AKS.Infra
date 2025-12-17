# Product Context

## Why This Project Exists
This project provides infrastructure automation for deploying AKS clusters to support microservices development. It enables teams to quickly provision consistent, secure, and cost-effective Kubernetes environments.

## Problems It Solves
1. **Manual Infrastructure Setup**: Eliminates error-prone manual Azure portal configurations
2. **Environment Consistency**: Ensures dev environments match expected patterns
3. **Cost Management**: Uses spot instances and right-sized VMs for cost optimization
4. **GitOps Enablement**: Pre-configures Flux for declarative application deployments
5. **Security Baseline**: Implements Azure AD authentication and RBAC out of the box

## How It Should Work
1. Developer clones repository
2. Updates `terraform.tfvars` with organization-specific values (ACR name, admin groups)
3. Runs `terraform apply` to provision complete AKS environment
4. Connects to cluster using Azure CLI
5. Deploys applications via GitOps (Flux) by pointing to application repositories

## User Experience Goals
- **Simple Onboarding**: < 30 minutes from clone to running cluster
- **Self-Service**: Developers can deploy without deep Azure expertise
- **Observable**: Built-in monitoring and logging from day one
- **Extensible**: Easy to add new environments (staging, prod)

## Integration Points
- **Azure AD (Entra ID)**: Authentication and authorization
- **Azure Container Registry**: Private container image storage
- **GitHub Actions**: CI/CD automation
- **Flux v2**: GitOps operator for application deployment
- **Container Insights**: Metrics and logging
