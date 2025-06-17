# Common Terraform Commands

This document provides examples and explanations for commonly used Terraform commands when working with this repository.

## Install
Install Chocolatey from: https://chocolatey.org/install
``` bash
choco install terraform
```

## 🚀 Basic Commands

### Initialize Terraform
```bash
# Basic initialization
terraform init

# Initialize with specific backend configuration
terraform init -backend-config="storage_account_name=myterraformstate" \
               -backend-config="container_name=tfstate" \
               -backend-config="key=myproject.tfstate"

# Initialize with plugin directory
terraform init -plugin-dir="./terraform.d/plugins"
```

### Format Terraform Files
```bash
# Format all .tf files in current directory
terraform fmt

# Format specific file
terraform fmt main.tf

# Format all .tf files recursively
terraform fmt -recursive

# Check if files are formatted without making changes
terraform fmt -check
```

### Validate Terraform Configuration
```bash
# Basic validation
terraform validate

# Validate with specific variables file
terraform validate -var-file="dev.tfvars"

# Validate with specific variables
terraform validate -var="environment=dev" -var="region=eastus"
```

### Apply Terraform Configuration
```bash
# Basic apply
terraform apply

# Apply with auto-approve (no confirmation prompt)
terraform apply -auto-approve

# Apply with specific variables file
terraform apply -var-file="prod.tfvars"

# Apply with specific variables
terraform apply -var="environment=prod" -var="region=westus"

# Apply with specific target
terraform apply -target="module.storage_account"

# Apply with parallel operations limit
terraform apply -parallelism=10
```

## 🔍 Additional Useful Commands

### Plan Changes
```bash
# Basic plan
terraform plan

# Plan with specific variables file
terraform plan -var-file="dev.tfvars"

# Plan with output file
terraform plan -out=tfplan

# Plan with specific target
terraform plan -target="module.storage_account"
```

### Show Current State
```bash
# Show current state
terraform show

# Show state in JSON format
terraform show -json

# Show specific resource
terraform show -json | jq '.values.root_module.resources[] | select(.address=="module.storage_account")'
```

### Import Existing Resources
```bash
# Import resource
terraform import module.storage_account.azurerm_storage_account.storage_account /subscriptions/{subscription-id}/resourceGroups/{resource-group}/providers/Microsoft.Storage/storageAccounts/{storage-account-name}
```

## 🛠️ Best Practices

1. **Always run `terraform fmt` before committing changes**
   - Ensures consistent formatting across the codebase
   - Makes code reviews easier
   - Prevents formatting-related merge conflicts

2. **Always run `terraform validate` before applying**
   - Catches syntax errors
   - Validates variable types
   - Ensures references are valid

3. **Use `-var-file` for environment-specific variables**
   - Keeps sensitive information out of version control
   - Makes it easier to manage different environments
   - Example: `dev.tfvars`, `staging.tfvars`, `prod.tfvars`

4. **Use `-target` sparingly**
   - Useful for debugging or fixing specific resources
   - Can lead to state inconsistencies if overused
   - Always run a full plan after targeted operations

5. **Always review the plan before applying**
   - Never use `-auto-approve` without reviewing the plan
   - Save the plan to a file for review: `terraform plan -out=tfplan`
   - Apply the saved plan: `terraform apply tfplan`

## ⚠️ Common Issues and Solutions

### State Lock Issues
```bash
# Force unlock the state
terraform force-unlock <LOCK_ID>
```

### Plugin Cache Issues
```bash
# Clear plugin cache
rm -rf .terraform/plugins

# Reinitialize
terraform init
```

### State File Corruption
```bash
# Backup current state
terraform state pull > terraform.tfstate.backup

# Remove corrupted state
rm terraform.tfstate

# Reinitialize and import resources
terraform init
terraform import ...
```

## 📝 Notes

- Always ensure you have the correct Azure credentials configured before running Terraform commands
- Use `terraform workspace` to manage multiple environments
- Consider using remote state storage for team environments
- Keep your Terraform version consistent across the team
- Use `.gitignore` to exclude `terraform` directories and state files 