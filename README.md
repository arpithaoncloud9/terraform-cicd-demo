
# Terraform + CI/CD Using GitHub Actions

## Overview:
This project automates Terraform deployments using GitHub Actions. It shows how IaC and CI/CD work together to deploy cloud resources automatically.

This small real‑world project will teaches you:
- Terraform basics
- Remote backend
- State management
- CI/CD pipeline
- GitHub Actions workflow
- Infrastructure automation

### **What You Will Build**

A tiny project with:

1. **Terraform code** that creates:
    
    - One S3 bucket
    - Tags
    - Versioning

2. **GitHub Actions pipeline** that runs:
    
    - `terraform fmt`
    - `terraform validate`
    - `terraform plan`
    - `terraform apply` (after approval)


### **Folder Structure** 

```
TERRAFORM-CICD-DEMO/
│
├── .github/
│   └── workflows/
│       └── terraform_cicd.yaml        # Your CI/CD pipeline
│
├── main.tf                            # Provider + resources
├── variables.tf                       # Input variables
├── terraform.tfvars                   # Values for variables
├── outputs.tf                         # Outputs (optional)
├── .gitignore                         # Ignore state files in Git
└── README.md                          # Documentation
```

### **Terraform Code (Very Simple)**

#### **main.tf**
```
resource "aws_s3_bucket" "demo" {
  bucket = var.bucket_name
  tags = {
    Environment = "dev"
  }
}
```
#### **variables.tf**
```
variable "bucket_name" {
  type = string
}
```
#### **outputs.tf**
```
output "bucket_name" {
  value = aws_s3_bucket.demo.bucket
}
```
### **Add AWS Credentials to GitHub Secrets**

Your pipeline cannot run Terraform without AWS access.

Go to your repo:

**Settings → Secrets and variables → Actions → New repository secret**

Add thses tow:

|Secret Name|Value|
|---|---|
|`AWS_ACCESS_KEY_ID`|your IAM user access key|
|`AWS_SECRET_ACCESS_KEY`|your IAM user secret key|

### **Create the environment in GitHub**

Go to:

**Repo → Settings → Environments → New environment**

Name it:
```
test
```
Add required reviewer:
```
arpithaoncloud9
```
Save.

### **GitHub Actions Workflow with  manual approval (terraform.yml)**

```yaml
name: Terraform CI/CD

on:
  push:
    branches: [ "main" ]

jobs:
  terraform:
    runs-on: ubuntu-latest

    # Add environment here (job level)
    environment:
      name: test

    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Configure AWS Credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-east-1

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v2

    - name: Terraform Init
      run: terraform init

    - name: Terraform Validate
      run: terraform validate

    - name: Terraform Plan
      run: terraform plan

    - name: Terraform Apply
      if: github.ref == 'refs/heads/main'
      run: terraform apply

```
#### Manual approval triggered — deployment awaiting review before proceeding.

<img width="590" height="328" alt="Screenshot 2026-02-24 at 4 12 24 PM" src="https://github.com/user-attachments/assets/b7909674-0e1b-4d86-8e85-d0475398733e" />


### **GitHub Actions Workflow with  NO manual approval (terraform.yml)**
```yaml
name: Terraform CI/CD

on:
  push:
    branches: [ "main" ]

jobs:
  terraform:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Configure AWS Credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-east-1

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v2

    - name: Terraform Init
      run: terraform init

    - name: Terraform Validate
      run: terraform validate

    - name: Terraform Plan
      run: terraform plan

    - name: Terraform Apply
      if: github.ref == 'refs/heads/main'
      run: terraform apply -auto-approve

```
#### Terraform initialized and validated successfully — configuration is clean and ready for deployment.

<img width="1036" height="597" alt="Screenshot 2026-02-24 at 4 09 22 PM" src="https://github.com/user-attachments/assets/13663be3-ad88-4703-9118-f525680d1dd0" />


#### Terraform Apply completed successfully — S3 bucket provisioned in a fully automated CI/CD pipeline.

<img width="1694" height="1174" alt="image" src="https://github.com/user-attachments/assets/e1587566-f7a1-4c35-a6cf-aec3b80ae122" />


#### CI/CD pipeline executed successfully — Terraform workflow completed.

<img width="1088" height="498" alt="Screenshot 2026-02-24 at 4 05 15 PM" src="https://github.com/user-attachments/assets/a184871d-0151-4b8b-b70a-920fa0d47ffe" />



### Outcome:
The project successfully automates Terraform deployments using GitHub Actions. Whenever I push code, the pipeline runs Terraform commands and applies the changes automatically.
