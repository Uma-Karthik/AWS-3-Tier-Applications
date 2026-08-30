AWS 3-Tier Architecture using Terraform & GitHub Actions
📌 Project Overview

This project demonstrates the deployment of a highly available, scalable, and secure 3-tier architecture on AWS using Terraform Infrastructure as Code (IaC) and GitHub Actions for CI/CD automation.

The architecture is deployed in the AWS us-east-1 region and separates the infrastructure into three logical tiers:

Presentation Tier – Public subnets hosting web servers
Application Tier – Private subnets hosting application servers
Data Tier – Private subnets hosting an Amazon RDS MySQL database

Terraform is used to provision and manage the AWS infrastructure, while GitHub Actions automates Terraform validation, planning, and deployment.

🏗️ Architecture
<img width="1536" height="1024" alt="AWS-3-Tier-application" src="https://github.com/user-attachments/assets/d757a429-1e9d-46ef-98c3-a4525069e751" />

## Repository Structure

```text
.
├── .github/workflows/
│   └── terraform.yml          # GitHub Actions CI/CD workflow
├── terraform/
│   ├── phase3.tf              # ALB, ASG, compute, and networking config
│   ├── rds.tf                 # RDS database and subnet group configuration
│   ├── variables.tf           # Input variable declarations
│   ├── outputs.tf             # Infrastructure outputs (ALB DNS, RDS endpoint)
│   └── provider.tf            # AWS provider and backend configuration
├── .gitignore
└── README.md
```

🔄 CI/CD Workflow

The project uses GitHub Actions to automate Terraform deployment.
```
Developer
    │
    ▼
GitHub Repository
    │
    ▼
GitHub Actions
    │
    ├── Checkout Code
    │
    ├── Setup Terraform
    │
    ├── Terraform Init
    │
    ├── Terraform Validate
    │
    ├── Terraform Plan
    │
    └── Terraform Apply
            │
            ▼
       AWS Infrastructure
```
## Local Deployment
```
Bash
# 1. Clone repository
git clone [https://github.com/Uma-Karthik/AWS-3-Tier-Applications.git](https://github.com/Uma-Karthik/AWS-3-Tier-Applications.git)
cd AWS-3-Tier-Applications/terraform

# 2. Initialize Terraform
terraform init

# 3. Preview execution plan
terraform plan \
  -var="db_username=admin" \
  -var="db_password=YourSecurePassword123!" \
  -var="alert_email=your-email@example.com"

# 4. Apply changes
terraform apply -auto-approve \
  -var="db_username=admin" \
  -var="db_password=YourSecurePassword123!" \
  -var="alert_email=your-email@example.com"
```
## Cleanup
To destroy all provisioned infrastructure and prevent ongoing AWS charges:
```
Bash
terraform destroy \
  -var="db_username=admin" \
  -var="db_password=YourSecurePassword123!" \
  -var="alert_email=your-email@example.com
```
