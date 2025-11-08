# React App Deployed on AWS

## Architecture

![Architecture Diagram](docs/architecture.png)

This project demonstrates deploying a React front-end application on AWS using **Terraform** and **GitHub Actions** for CI/CD. The architecture ensures global delivery via CloudFront, secure HTTPS through ACM, and infrastructure managed as code.

---

## Components

| Component | Description |
|-----------|-------------|
| **GitHub Repository** | Contains the React front-end and Terraform code for AWS infrastructure. |
| **GitHub Actions (CI/CD)** | Automates build, test, Terraform plan/apply, and deployment of the React app. |
| **Terraform** | Infrastructure as code managing: S3 bucket, CloudFront distribution, ACM certificate, and optionally Route53. |
| **S3 Bucket** | Stores the React build files for static hosting. |
| **CloudFront Distribution** | Serves the React app globally, provides caching, and enforces HTTPS. |
| **ACM Certificate** | TLS/SSL certificate for secure HTTPS connections. |
| **Route53 (optional)** | Manages domain DNS and validates ACM certificates via DNS. |

---

## Repository Secrets

Before running workflows, set the following **GitHub repository secrets**:

| Secret Name   | Purpose |
|---------------|---------|
| `AWS_REGION`  | AWS region to deploy resources (e.g., us-east-1) |
| `BUCKET_NAME` | Name of the S3 bucket for hosting the React app |
| `IAM_ROLE`    | IAM role ARN assumed by GitHub Actions to deploy resources |

---

## Getting Started

### Prerequisites
- GitHub account  
- AWS account  
- Node.js v20  
- Terraform (v1.9.8; installed automatically by GitHub Actions)  

### Run Locally
```bash
git clone https://github.com/your-username/your-repo.git
cd your-repo/front
npm ci
npm start

### Deployment

This project uses GitHub Actions workflows:

CI workflow: Lints, tests, builds React app, and creates a Terraform plan.

CD workflow: Applies Terraform plan, uploads React build to S3, and invalidates CloudFront cache.

Workflows can be triggered manually or on push to main.

### Destroying Infrastructure

Use the Destroy workflow in GitHub Actions to:

Empty the S3 bucket

Delete Terraform-managed resources (CloudFront, S3, ACM, Route53)

# Trigger GitHub Actions "Destroy" workflow or run locally
terraform destroy -auto-approve

### Notes

Terraform manages all infrastructure: S3, CloudFront, ACM, and optionally Route53.

Manual edits to S3 or CloudFront may be overwritten on the next deploy.

If you do not have a domain, Route53/ACM steps will fail, but S3 + CloudFront will still deploy your app.