
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


### **Folder Structure 

```
terraform-cicd-demo/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── backend.tf
└── .github/
    └── workflows/
        └── terraform.yml
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


### Outcome:
The project successfully automates Terraform deployments using GitHub Actions. Whenever I push code, the pipeline runs Terraform commands and applies the changes automatically.