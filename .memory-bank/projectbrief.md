# AKS Infrastructure Project Brief

## Project Overview
Terraform Infrastructure as Code (IaC) project for deploying Azure Kubernetes Service (AKS) clusters with a focus on microservices architecture.

## Primary Goals
1. Deploy cost-optimized AKS dev cluster in West US 2
2. Enable GitOps (Flux v2) for declarative deployments
3. Support microservices and API workloads with cronjobs
4. Implement Azure AD authentication with Azure RBAC
5. Provide CI/CD pipeline via GitHub Actions

## Target Users
- Small development team (2 developers)
- Microservices/API development focus

## Key Requirements
- **Region**: West US 2
- **Cost Optimization**: Budget-conscious dev environment
- **Service Mesh**: Istio to be deployed via GitOps (not the AKS add-on)
- **Authentication**: Azure AD (Entra ID) integration
- **API Access**: Public API server
- **Monitoring**: Container Insights with Log Analytics

## Success Criteria
- Terraform validates and deploys successfully
- Cluster accessible via kubectl
- GitOps (Flux) operational for application deployments
- Estimated monthly cost under $100
