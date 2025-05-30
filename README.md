# Azure Shared Infrastructure

This repository contains the Terraform configuration for managing shared Azure infrastructure resources for my personal Azure account and associated projects, including cezzis.com. The infrastructure is deployed using GitHub Actions and follows Azure best practices for naming conventions and resource organization.

## 🏗️ Infrastructure Components

The following Azure resources are managed by this repository:

- **Azure Key Vault**: Secure storage for secrets, keys, and certificates
- **Azure Service Bus**: Enterprise messaging service for decoupled applications
- **Azure API Management (APIM)**: API gateway and management platform
- **Application Insights**: Application performance monitoring and diagnostics
- **DNS Zone**: Domain name system management
- **Container Apps Environment**: Managed environment for containerized applications
- **Front Door CDN**: Content delivery network and global load balancing
- **Virtual Network**: Network infrastructure with subnets
- **Monitoring**: Azure Monitor resources for observability

## 🚀 Deployment

The infrastructure is deployed using GitHub Actions workflows. The deployment process includes:

1. Terraform plan and apply steps
2. Environment-specific configurations
3. Secure handling of Azure credentials

### Prerequisites

- Azure subscription
- Azure service principal with appropriate permissions
- GitHub repository secrets configured:
  - `ARM_CLIENT_ID`
  - `ARM_CLIENT_SECRET`
  - `ARM_SUBSCRIPTION_ID`
  - `ARM_TENANT_ID`
  - `TERRAFORM_MODULE_REPO_ACCESS_KEY_SECRET`

## 🔧 Configuration

The infrastructure is configured using Terraform variables defined in `variables.tf`. Key configuration parameters include:

- Environment name
- Azure region
- Resource naming conventions
- Resource group names
- Network configurations

## 📁 Repository Structure

```
.
├── .github/
│   └── workflows/
│       └── shared-infrastructure-cicd.yaml
└── .terraform/
    ├── main.tf
    ├── variables.tf
    ├── locals.tf
    └── [resource-specific].tf files
```

## 🔐 Security

- Azure Key Vault is used for secure secret management
- Service principal authentication for deployments
- Network security through VNet integration
- RBAC controls for resource access

## 🔄 CI/CD

The infrastructure is automatically deployed through GitHub Actions when changes are pushed to the main branch. The workflow:

1. Triggers on pull requests and pushes to main
2. Uses reusable workflow from `mtnvencenzo/workflows`
3. Supports manual triggers through workflow_dispatch
4. Implements proper state management using Azure Storage backend

## 📚 Terraform Setup

- [Terraform Commands Reference](.readme/terraform-commands.md) - Common Terraform commands and their usage


## 📝 Contributing

1. Create a feature branch
2. Make your changes
3. Submit a pull request
4. Ensure CI/CD checks pass
5. Get approval from maintainers

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

