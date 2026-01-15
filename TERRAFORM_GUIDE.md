# Terraform Beginner's Guide

## Table of Contents
1. [Introduction](#introduction)
2. [What is Terraform?](#what-is-terraform)
3. [Installation](#installation)
4. [Core Concepts](#core-concepts)
5. [Getting Started](#getting-started)
6. [Basic Syntax](#basic-syntax)
7. [Essential Commands](#essential-commands)
8. [Working with Providers](#working-with-providers)
9. [State Management](#state-management)
10. [Variables and Outputs](#variables-and-outputs)
11. [Modules](#modules)
12. [Best Practices](#best-practices)
13. [Common Use Cases](#common-use-cases)
14. [Troubleshooting](#troubleshooting)
15. [Resources for Learning](#resources-for-learning)

---

## Introduction

Welcome to the Terraform Beginner's Guide! This comprehensive guide will help you understand and master Infrastructure as Code (IaC) using Terraform, regardless of your prior experience.

**Who is this guide for?**
- Beginners with no Terraform experience
- DevOps engineers transitioning to IaC
- System administrators looking to automate infrastructure
- Developers wanting to understand infrastructure deployment

---

## What is Terraform?

### Overview

**Terraform** is an open-source Infrastructure as Code (IaC) tool created by HashiCorp. It allows you to define and provision infrastructure using a declarative configuration language.

### Key Features

- **Infrastructure as Code (IaC)**: Define infrastructure in human-readable configuration files
- **Multi-Cloud Support**: Works with AWS, Azure, GCP, and 100+ providers
- **Declarative Syntax**: Describe the desired end state, not the steps to get there
- **Execution Plans**: Preview changes before applying them
- **Resource Graph**: Understands dependencies between resources
- **State Management**: Tracks real-world infrastructure state

### Why Use Terraform?

✅ **Automation**: Automate infrastructure provisioning and management
✅ **Consistency**: Ensure identical environments across dev, staging, and production
✅ **Version Control**: Track infrastructure changes using Git
✅ **Collaboration**: Enable team collaboration on infrastructure
✅ **Cost Optimization**: Destroy resources when not needed
✅ **Disaster Recovery**: Quickly recreate infrastructure from code

### Terraform vs Other Tools

| Tool | Type | Use Case |
|------|------|----------|
| **Terraform** | Declarative IaC | Multi-cloud infrastructure provisioning |
| **CloudFormation** | Declarative IaC | AWS-specific infrastructure |
| **Ansible** | Configuration Management | Software provisioning and configuration |
| **Pulumi** | Imperative IaC | Infrastructure using general-purpose languages |

---

## Installation

### Prerequisites

- Operating System: Linux, macOS, or Windows
- Terminal/Command Line access
- (Optional) Cloud provider account (AWS, Azure, GCP)

### Installation Methods

#### Method 1: Official Binary (Recommended)

**Linux/macOS:**
```bash
# Download Terraform
wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip

# Unzip
unzip terraform_1.6.6_linux_amd64.zip

# Move to PATH
sudo mv terraform /usr/local/bin/

# Verify installation
terraform --version
```

**Windows (PowerShell):**
```powershell
# Download from https://www.terraform.io/downloads
# Extract and add to PATH environment variable
# Verify:
terraform --version
```

#### Method 2: Package Managers

**macOS (Homebrew):**
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

**Ubuntu/Debian:**
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

**Windows (Chocolatey):**
```powershell
choco install terraform
```

#### Verify Installation

```bash
terraform --version
# Output: Terraform v1.6.6
```

---

## Core Concepts

### 1. Providers

**Definition**: Plugins that interact with cloud providers, SaaS providers, and APIs.

**Examples**: AWS, Azure, GCP, Kubernetes, GitHub, Datadog

```hcl
provider "aws" {
  region = "us-west-2"
}
```

### 2. Resources

**Definition**: Infrastructure components you want to create (VMs, networks, databases, etc.)

```hcl
resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```

### 3. Data Sources

**Definition**: Query existing infrastructure or external data without creating new resources.

```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
}
```

### 4. Variables

**Definition**: Input parameters to make configurations reusable and flexible.

```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
```

### 5. Outputs

**Definition**: Extract information about resources after creation.

```hcl
output "instance_ip" {
  value = aws_instance.web_server.public_ip
}
```

### 6. State

**Definition**: Terraform's database that maps configuration to real-world infrastructure.

- Stored in `terraform.tfstate` file
- Tracks resource metadata and dependencies
- Critical for Terraform operations

### 7. Modules

**Definition**: Reusable, shareable collections of Terraform configurations.

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"
}
```

---

## Getting Started

### Your First Terraform Project

#### Step 1: Create Project Directory

```bash
mkdir terraform-demo
cd terraform-demo
```

#### Step 2: Create Configuration File

Create `main.tf`:

```hcl
# Configure the provider
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Create a local file resource
resource "local_file" "hello" {
  filename = "${path.module}/hello.txt"
  content  = "Hello, Terraform!"
}

# Output the file path
output "file_path" {
  value = local_file.hello.filename
}
```

#### Step 3: Initialize Terraform

```bash
terraform init
```

**What happens:**
- Downloads required provider plugins
- Creates `.terraform` directory
- Initializes backend for state storage

#### Step 4: Plan Changes

```bash
terraform plan
```

**What happens:**
- Shows what resources will be created/modified/destroyed
- No actual changes are made
- Preview before applying

#### Step 5: Apply Changes

```bash
terraform apply
```

**What happens:**
- Prompts for confirmation (type `yes`)
- Creates resources as defined
- Updates state file

#### Step 6: Verify

```bash
cat hello.txt
# Output: Hello, Terraform!
```

#### Step 7: Destroy Resources

```bash
terraform destroy
```

**What happens:**
- Removes all managed resources
- Prompts for confirmation

---

## Basic Syntax

### HCL (HashiCorp Configuration Language)

Terraform uses HCL, a declarative language designed for infrastructure.

#### Block Structure

```hcl
<BLOCK_TYPE> "<BLOCK_LABEL>" "<BLOCK_NAME>" {
  # Block body
  <IDENTIFIER> = <EXPRESSION>
}
```

#### Comments

```hcl
# Single line comment

// Another single line comment

/*
Multi-line
comment
*/
```

#### String Interpolation

```hcl
resource "aws_instance" "example" {
  tags = {
    Name = "Instance for ${var.environment}"
  }
}
```

#### Lists and Maps

```hcl
# List
variable "availability_zones" {
  type    = list(string)
  default = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

# Map
variable "instance_types" {
  type = map(string)
  default = {
    dev  = "t2.micro"
    prod = "t2.large"
  }
}
```

#### Conditional Expressions

```hcl
resource "aws_instance" "example" {
  instance_type = var.environment == "prod" ? "t2.large" : "t2.micro"
}
```

#### For Expressions

```hcl
locals {
  uppercase_names = [for name in var.names : upper(name)]
}
```

---

## Essential Commands

### terraform init

**Purpose**: Initialize a Terraform working directory

```bash
terraform init
```

**Options:**
```bash
terraform init -upgrade      # Upgrade provider plugins
terraform init -reconfigure  # Reconfigure backend
```

### terraform plan

**Purpose**: Preview changes before applying

```bash
terraform plan
```

**Options:**
```bash
terraform plan -out=plan.tfplan  # Save plan to file
terraform plan -var="env=prod"   # Pass variable
terraform plan -target=aws_instance.web  # Target specific resource
```

### terraform apply

**Purpose**: Create or update infrastructure

```bash
terraform apply
```

**Options:**
```bash
terraform apply -auto-approve     # Skip confirmation prompt
terraform apply plan.tfplan       # Apply saved plan
terraform apply -var-file=prod.tfvars  # Use variable file
```

### terraform destroy

**Purpose**: Destroy all managed infrastructure

```bash
terraform destroy
```

**Options:**
```bash
terraform destroy -auto-approve  # Skip confirmation
terraform destroy -target=aws_instance.web  # Destroy specific resource
```

### terraform fmt

**Purpose**: Format configuration files

```bash
terraform fmt
```

**Options:**
```bash
terraform fmt -recursive  # Format all subdirectories
terraform fmt -check      # Check if formatting is needed
```

### terraform validate

**Purpose**: Validate configuration syntax

```bash
terraform validate
```

### terraform show

**Purpose**: Show current state or saved plan

```bash
terraform show
terraform show plan.tfplan
```

### terraform output

**Purpose**: Display output values

```bash
terraform output              # Show all outputs
terraform output instance_ip  # Show specific output
```

### terraform state

**Purpose**: Advanced state management

```bash
terraform state list                    # List resources in state
terraform state show aws_instance.web   # Show resource details
terraform state mv SOURCE DESTINATION   # Move resource in state
terraform state rm aws_instance.web     # Remove resource from state
```

### terraform import

**Purpose**: Import existing infrastructure into Terraform

```bash
terraform import aws_instance.web i-1234567890abcdef0
```

### terraform workspace

**Purpose**: Manage multiple environments with workspaces

```bash
terraform workspace list        # List workspaces
terraform workspace new dev     # Create new workspace
terraform workspace select dev  # Switch workspace
```

---

## Working with Providers

### What are Providers?

Providers are plugins that enable Terraform to interact with cloud platforms, SaaS providers, and other APIs.

### Configuring Providers

#### AWS Provider

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "us-west-2"
  access_key = var.aws_access_key  # Better: use AWS CLI credentials
  secret_key = var.aws_secret_key
}
```

**Best Practice**: Use AWS CLI configured credentials instead of hardcoding:

```bash
aws configure
```

```hcl
provider "aws" {
  region = "us-west-2"
  # Credentials automatically loaded from ~/.aws/credentials
}
```

#### Azure Provider

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}
```

#### Google Cloud Provider

```hcl
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "my-project-id"
  region  = "us-central1"
  credentials = file("service-account-key.json")
}
```

### Multiple Provider Instances

You can use multiple instances of the same provider:

```hcl
provider "aws" {
  alias  = "us_west"
  region = "us-west-2"
}

provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}

resource "aws_instance" "west" {
  provider      = aws.us_west
  ami           = "ami-12345678"
  instance_type = "t2.micro"
}

resource "aws_instance" "east" {
  provider      = aws.us_east
  ami           = "ami-87654321"
  instance_type = "t2.micro"
}
```

### Popular Providers

| Provider | Use Case |
|----------|----------|
| `hashicorp/aws` | Amazon Web Services |
| `hashicorp/azurerm` | Microsoft Azure |
| `hashicorp/google` | Google Cloud Platform |
| `hashicorp/kubernetes` | Kubernetes clusters |
| `hashicorp/docker` | Docker containers |
| `hashicorp/local` | Local files and commands |
| `hashicorp/null` | Utility provider for testing |
| `integrations/github` | GitHub repositories |

---

## State Management

### What is Terraform State?

The state file (`terraform.tfstate`) is Terraform's source of truth about your infrastructure.

**Contains:**
- Resource metadata
- Resource dependencies
- Current infrastructure state
- Provider configuration

### Local vs Remote State

#### Local State (Default)

```bash
# State stored in terraform.tfstate in current directory
```

**Pros:**
- Simple for learning
- No additional setup

**Cons:**
- Not suitable for teams
- Risk of state file loss
- No locking mechanism

#### Remote State (Recommended for Production)

**AWS S3 Backend:**

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "prod/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}
```

**Setup DynamoDB for locking:**

```hcl
resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
```

**Terraform Cloud Backend:**

```hcl
terraform {
  backend "remote" {
    organization = "my-org"

    workspaces {
      name = "my-workspace"
    }
  }
}
```

### State Commands

```bash
# View state
terraform show

# List resources in state
terraform state list

# Show specific resource
terraform state show aws_instance.web

# Pull remote state locally
terraform state pull

# Push local state to remote
terraform state push

# Move resource in state (rename)
terraform state mv aws_instance.old aws_instance.new

# Remove resource from state (without destroying)
terraform state rm aws_instance.web
```

### State Locking

Prevents concurrent modifications to state:

```hcl
# Automatically enabled with supported backends (S3 + DynamoDB, Terraform Cloud)
terraform apply  # Acquires lock
# Another user runs terraform apply -> blocked until lock released
```

### Best Practices

✅ **Always use remote state for teams**
✅ **Enable state locking**
✅ **Encrypt state at rest**
✅ **Never edit state files manually**
✅ **Use `terraform state` commands for modifications**
✅ **Back up state files regularly**
❌ **Never commit state files to Git**

---

## Variables and Outputs

### Input Variables

#### Declaring Variables

**variables.tf:**

```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "environment" {
  description = "Environment name"
  type        = string
  # No default = required variable
}

variable "availability_zones" {
  description = "List of AZs"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default = {
    Project = "Demo"
    Owner   = "DevOps"
  }
}
```

#### Variable Types

```hcl
# String
variable "region" {
  type    = string
  default = "us-west-2"
}

# Number
variable "instance_count" {
  type    = number
  default = 3
}

# Bool
variable "enable_monitoring" {
  type    = bool
  default = true
}

# List
variable "subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

# Map
variable "ami_ids" {
  type = map(string)
  default = {
    us-west-2 = "ami-123456"
    us-east-1 = "ami-654321"
  }
}

# Object
variable "server_config" {
  type = object({
    instance_type = string
    volume_size   = number
    enable_public_ip = bool
  })
  default = {
    instance_type    = "t2.micro"
    volume_size      = 20
    enable_public_ip = true
  }
}
```

#### Using Variables

```hcl
resource "aws_instance" "web" {
  ami           = var.ami_ids[var.region]
  instance_type = var.instance_type

  tags = merge(
    var.tags,
    {
      Name = "WebServer-${var.environment}"
    }
  )
}
```

#### Providing Variable Values

**Method 1: Command Line**
```bash
terraform apply -var="environment=prod" -var="instance_type=t2.large"
```

**Method 2: Variable Files**

**terraform.tfvars:** (automatically loaded)
```hcl
environment   = "production"
instance_type = "t2.large"
```

**prod.tfvars:** (explicitly specified)
```hcl
environment   = "production"
instance_type = "t2.large"
```

```bash
terraform apply -var-file="prod.tfvars"
```

**Method 3: Environment Variables**
```bash
export TF_VAR_environment="prod"
export TF_VAR_instance_type="t2.large"
terraform apply
```

**Method 4: Interactive Prompt**
```bash
# Terraform prompts for variables without defaults
terraform apply
# var.environment
#   Environment name
#   Enter a value: production
```

#### Variable Validation

```hcl
variable "instance_type" {
  type        = string
  description = "EC2 instance type"

  validation {
    condition     = can(regex("^t2\\.", var.instance_type))
    error_message = "Instance type must be in t2 family."
  }
}

variable "environment" {
  type        = string
  description = "Environment name"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}
```

### Output Values

#### Declaring Outputs

**outputs.tf:**

```hcl
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "Public IP address"
  value       = aws_instance.web.public_ip
}

output "instance_private_ip" {
  description = "Private IP address"
  value       = aws_instance.web.private_ip
  sensitive   = true  # Won't show in CLI output
}

output "connection_string" {
  description = "SSH connection string"
  value       = "ssh ubuntu@${aws_instance.web.public_ip}"
}
```

#### Using Outputs

**View all outputs:**
```bash
terraform output
```

**View specific output:**
```bash
terraform output instance_public_ip
```

**Output as JSON:**
```bash
terraform output -json
```

**Use in scripts:**
```bash
INSTANCE_IP=$(terraform output -raw instance_public_ip)
ssh ubuntu@$INSTANCE_IP
```

#### Output Between Modules

```hcl
# In module
output "vpc_id" {
  value = aws_vpc.main.id
}

# Using module output
module "vpc" {
  source = "./modules/vpc"
}

resource "aws_subnet" "app" {
  vpc_id = module.vpc.vpc_id
}
```

---

## Modules

### What are Modules?

Modules are containers for multiple resources used together. They enable:
- Code reusability
- Organization
- Encapsulation
- Sharing across teams

### Module Structure

```
modules/
└── webserver/
    ├── main.tf         # Resources
    ├── variables.tf    # Input variables
    ├── outputs.tf      # Output values
    └── README.md       # Documentation
```

### Creating a Module

**modules/webserver/variables.tf:**

```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "server_name" {
  description = "Name tag for server"
  type        = string
}
```

**modules/webserver/main.tf:**

```hcl
resource "aws_instance" "server" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = var.server_name
  }
}

resource "aws_security_group" "web" {
  name        = "${var.server_name}-sg"
  description = "Security group for ${var.server_name}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

**modules/webserver/outputs.tf:**

```hcl
output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.server.id
}

output "public_ip" {
  description = "Public IP address"
  value       = aws_instance.server.public_ip
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.web.id
}
```

### Using a Module

**Root main.tf:**

```hcl
module "webserver_dev" {
  source = "./modules/webserver"

  instance_type = "t2.micro"
  ami_id        = "ami-0c55b159cbfafe1f0"
  server_name   = "dev-web-server"
}

module "webserver_prod" {
  source = "./modules/webserver"

  instance_type = "t2.large"
  ami_id        = "ami-0c55b159cbfafe1f0"
  server_name   = "prod-web-server"
}

# Access module outputs
output "dev_server_ip" {
  value = module.webserver_dev.public_ip
}

output "prod_server_ip" {
  value = module.webserver_prod.public_ip
}
```

### Public Modules (Terraform Registry)

**Using a registry module:**

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Environment = "dev"
  }
}
```

**Popular public modules:**
- `terraform-aws-modules/vpc/aws` - AWS VPC
- `terraform-aws-modules/eks/aws` - AWS EKS
- `terraform-aws-modules/rds/aws` - AWS RDS
- `Azure/aks/azurerm` - Azure AKS

### Module Best Practices

✅ **Use semantic versioning for modules**
✅ **Document module inputs/outputs in README**
✅ **Keep modules focused and single-purpose**
✅ **Pin module versions in production**
✅ **Include examples in module repositories**
✅ **Test modules before publishing**

---

## Best Practices

### 1. Code Organization

```
project/
├── main.tf           # Main resources
├── variables.tf      # Input variables
├── outputs.tf        # Output values
├── providers.tf      # Provider configuration
├── backend.tf        # Backend configuration
├── versions.tf       # Terraform/provider version constraints
├── terraform.tfvars  # Variable values (don't commit secrets!)
├── .gitignore        # Git ignore file
└── modules/          # Custom modules
    └── vpc/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

### 2. Version Constraints

**versions.tf:**

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Allow 5.x versions
    }
  }
}
```

### 3. .gitignore

```gitignore
# Local .terraform directories
**/.terraform/*

# .tfstate files
*.tfstate
*.tfstate.*

# Crash log files
crash.log

# Variable files that may contain secrets
*.tfvars
*.tfvars.json

# Ignore override files
override.tf
override.tf.json

# Ignore CLI configuration files
.terraformrc
terraform.rc

# Plans
*.tfplan
```

### 4. Use Workspaces for Environments

```bash
# Create workspaces
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod

# Switch workspaces
terraform workspace select dev

# Use workspace in config
resource "aws_instance" "web" {
  instance_type = terraform.workspace == "prod" ? "t2.large" : "t2.micro"

  tags = {
    Environment = terraform.workspace
  }
}
```

### 5. Use Data Sources

```hcl
# Don't hardcode AMI IDs
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "web" {
  ami = data.aws_ami.ubuntu.id
}
```

### 6. Use Locals for Computed Values

```hcl
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    CreatedAt   = timestamp()
  }

  name_prefix = "${var.project_name}-${var.environment}"
}

resource "aws_instance" "web" {
  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-web-server"
    }
  )
}
```

### 7. Implement Resource Tagging

```hcl
variable "common_tags" {
  type = map(string)
  default = {
    Project     = "MyApp"
    Environment = "Production"
    ManagedBy   = "Terraform"
    Team        = "DevOps"
  }
}

resource "aws_instance" "web" {
  tags = var.common_tags
}
```

### 8. Use Depends_on Sparingly

Terraform automatically determines dependencies. Use `depends_on` only when necessary:

```hcl
resource "aws_iam_role_policy" "example" {
  role   = aws_iam_role.example.name
  policy = data.aws_iam_policy_document.example.json

  # Only use when implicit dependency isn't detected
  depends_on = [aws_iam_role.example]
}
```

### 9. Enable Logging

```bash
# Enable detailed logs
export TF_LOG=DEBUG
export TF_LOG_PATH=./terraform.log
terraform apply
```

### 10. Security Best Practices

❌ **Never hardcode credentials**

```hcl
# BAD
provider "aws" {
  access_key = "AKIAIOSFODNN7EXAMPLE"
  secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
}
```

✅ **Use environment variables or credential files**

```hcl
# GOOD
provider "aws" {
  region = "us-west-2"
  # Credentials from ~/.aws/credentials or environment
}
```

✅ **Encrypt state files**
✅ **Use secrets managers for sensitive data**
✅ **Implement least privilege IAM policies**
✅ **Enable MFA for state bucket access**
✅ **Regularly rotate credentials**

---

## Common Use Cases

### 1. Provision EC2 Instance (AWS)

```hcl
provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "HelloTerraform"
  }
}

output "instance_ip" {
  value = aws_instance.web.public_ip
}
```

### 2. Create VPC with Subnets

```hcl
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}
```

### 3. Deploy Docker Container

```hcl
provider "docker" {}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "nginx" {
  name  = "my-nginx"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = 8080
  }
}

output "container_id" {
  value = docker_container.nginx.id
}
```

### 4. Create S3 Bucket with Versioning

```hcl
resource "aws_s3_bucket" "data" {
  bucket = "my-terraform-state-bucket-12345"

  tags = {
    Name        = "Terraform State"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_versioning" "data" {
  bucket = aws_s3_bucket.data.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data" {
  bucket = aws_s3_bucket.data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
```

### 5. Provision Azure VM

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_F2"
  admin_username      = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
```

---

## Troubleshooting

### Common Errors and Solutions

#### 1. Provider Plugin Not Found

**Error:**
```
Error: Could not load plugin
Plugin reinitialization required. Please run "terraform init".
```

**Solution:**
```bash
terraform init
```

#### 2. State Lock Error

**Error:**
```
Error: Error acquiring the state lock
```

**Solution:**
```bash
# Force unlock (use with caution!)
terraform force-unlock <LOCK_ID>
```

#### 3. Resource Already Exists

**Error:**
```
Error: A resource with the ID "..." already exists
```

**Solution:**
```bash
# Import existing resource
terraform import aws_instance.web i-1234567890abcdef0

# OR remove from state
terraform state rm aws_instance.web
```

#### 4. Circular Dependency

**Error:**
```
Error: Cycle: aws_instance.a, aws_instance.b
```

**Solution:**
- Review resource dependencies
- Remove or restructure circular references
- Use data sources instead of resource references

#### 5. Invalid Configuration Syntax

**Error:**
```
Error: Unsupported argument
```

**Solution:**
```bash
# Validate configuration
terraform validate

# Format code
terraform fmt
```

#### 6. Insufficient Permissions

**Error:**
```
Error: Error creating resource: UnauthorizedOperation
```

**Solution:**
- Verify IAM permissions
- Check AWS credentials
- Ensure correct provider configuration

### Debugging Tips

**Enable verbose logging:**
```bash
export TF_LOG=DEBUG
export TF_LOG_PATH=./terraform-debug.log
terraform apply
```

**Log levels:**
- `TRACE` - Most detailed
- `DEBUG` - Detailed debugging
- `INFO` - Informational messages
- `WARN` - Warnings
- `ERROR` - Errors only

**Validate before apply:**
```bash
terraform validate  # Check syntax
terraform fmt       # Format code
terraform plan      # Preview changes
```

**Use targeted operations:**
```bash
# Apply only specific resource
terraform apply -target=aws_instance.web

# Destroy only specific resource
terraform destroy -target=aws_instance.web
```

---

## Resources for Learning

### Official Documentation

- **Terraform Website**: https://www.terraform.io
- **Documentation**: https://developer.hashicorp.com/terraform/docs
- **Tutorials**: https://developer.hashicorp.com/terraform/tutorials
- **Registry**: https://registry.terraform.io

### Online Courses

- **HashiCorp Learn**: Free official tutorials
- **A Cloud Guru**: Terraform courses
- **Udemy**: Various Terraform courses
- **Linux Academy**: DevOps and Terraform

### Books

- **Terraform: Up & Running** by Yevgeniy Brikman
- **Getting Started with Terraform** by Kishore Kumar
- **Infrastructure as Code** by Kief Morris

### Community Resources

- **GitHub**: https://github.com/hashicorp/terraform
- **Community Forum**: https://discuss.hashicorp.com/c/terraform-core
- **Stack Overflow**: Tag `terraform`
- **Reddit**: r/Terraform

### Practice Projects

1. **Simple**: Deploy a static website to S3
2. **Intermediate**: Create a multi-tier web application
3. **Advanced**: Build a complete EKS cluster with monitoring
4. **Expert**: Implement multi-cloud disaster recovery

### Certification

**HashiCorp Certified: Terraform Associate**
- Validates Terraform skills
- Covers core concepts and workflows
- Exam format: 60 minutes, 57 questions
- Cost: $70.50 USD
- Study guide: https://developer.hashicorp.com/terraform/tutorials/certification-003

---

## Quick Reference Cheat Sheet

### Essential Commands

```bash
# Initialize
terraform init

# Validate
terraform validate

# Format
terraform fmt

# Plan
terraform plan

# Apply
terraform apply

# Destroy
terraform destroy

# Show state
terraform show

# List resources
terraform state list

# Output values
terraform output
```

### Resource Syntax

```hcl
resource "provider_resource" "name" {
  argument1 = "value1"
  argument2 = "value2"
}
```

### Variable Syntax

```hcl
variable "name" {
  description = "Description"
  type        = string
  default     = "default_value"
}
```

### Output Syntax

```hcl
output "name" {
  description = "Description"
  value       = resource.name.attribute
}
```

### Module Syntax

```hcl
module "name" {
  source = "./path/to/module"

  input1 = "value1"
  input2 = "value2"
}
```

---

## Conclusion

Congratulations on completing this Terraform beginner's guide! You now have a solid foundation in Infrastructure as Code using Terraform.

### Next Steps

1. **Practice**: Build simple projects and gradually increase complexity
2. **Read Documentation**: Familiarize yourself with provider documentation
3. **Join Communities**: Engage with the Terraform community
4. **Contribute**: Share your modules and help others
5. **Get Certified**: Consider HashiCorp Terraform Associate certification

### Key Takeaways

✅ Terraform enables Infrastructure as Code across multiple clouds
✅ Declarative syntax makes infrastructure predictable and versionable
✅ State management is critical for tracking real-world infrastructure
✅ Modules promote code reusability and organization
✅ Best practices ensure secure, maintainable infrastructure

---

**Happy Terraforming! 🚀**

*Last Updated: 2026-01-15*
*Version: 1.0.0*
