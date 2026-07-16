# 🚀 Acme Web Design – Cloud Native Deployment on Google Cloud

A production-style Cloud Engineering project demonstrating how to build, secure, deploy, and automate a containerized web application using Google Cloud Platform.

---

# 📌 Project Overview

This project demonstrates a complete cloud-native deployment workflow starting from a Dockerized application and ending with an automated deployment to Google Kubernetes Engine (GKE) using GitHub Actions CI/CD and Infrastructure as Code (Terraform).

The project follows production-oriented DevOps practices including:

- Infrastructure as Code (Terraform)
- Docker containerization
- Kubernetes deployment
- Google Kubernetes Engine (GKE)
- GitHub Actions CI/CD
- Workload Identity Federation
- Security scanning using Trivy
- Health Checks
- Network Policies

---

# 🏗 Architecture

```
Developer
    │
    ▼
GitHub Repository
    │
    ▼
GitHub Actions CI/CD
    │
    ├── Build Docker Image
    ├── Push to Docker Hub
    ├── Trivy Security Scan
    ├── Deploy to GKE
    └── Health Check
    │
    ▼
Docker Hub
    │
    ▼
Google Kubernetes Engine
    │
    ▼
LoadBalancer Service
    │
    ▼
Public Website
```

---

# ☁ Technologies

- Google Cloud Platform (GCP)
- Google Kubernetes Engine (GKE)
- Terraform
- Docker
- Docker Hub
- Kubernetes
- GitHub Actions
- Workload Identity Federation
- IAM
- Network Policies
- Nginx
- Python
- Trivy Security Scanner

---

# ✨ Features

- Dockerized Static Website
- Secure Nginx Configuration
- Non-root Container
- Kubernetes Deployment
- Kubernetes LoadBalancer Service
- Network Policy
- Health Checks
- Infrastructure as Code using Terraform
- Automated CI/CD Pipeline
- Docker Image Security Scan
- Automated Kubernetes Deployment
- Google Cloud Workload Identity Federation

---

# 🔄 CI/CD Pipeline

The GitHub Actions pipeline performs the following stages automatically:

1. Checkout Repository
2. Build Docker Image
3. Push Image to Docker Hub
4. Security Scan using Trivy
5. Authenticate to Google Cloud
6. Deploy to Google Kubernetes Engine
7. Run Health Check

---

# 📂 Project Structure

```text
.
├── Dockerfile
├── nginx.conf
├── README.md
├── k8s
│   ├── deployment.yaml
│   ├── service.yaml
│   └── network-policy.yaml
├── terraform
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── versions.tf
├── scripts
│   └── health_check.py
└── .github
    └── workflows
        └── ci-cd.yml
```

---

# 🚀 Deployment Process

### Build Docker Image

```bash
docker build -t islamahmad9/acme-web-design:v4 .
```

### Push Image

```bash
docker push islamahmad9/acme-web-design:v4
```

### Provision Infrastructure

```bash
terraform init
terraform plan
terraform apply
```

### Deploy Application

```bash
kubectl apply -f k8s/
```

### Verify Deployment

```bash
kubectl get pods
kubectl get svc
```

---

# 📷 Project Screenshots

- ✅ GitHub Repository
- ✅ GitHub Actions Pipeline
- ✅ Docker Hub Image
- ✅ Terraform Apply
- ✅ GKE Cluster
- ✅ Kubernetes Pods
- ✅ Kubernetes Services
- ✅ LoadBalancer
- ✅ Running Website

---

# 🔐 Security

- Workload Identity Federation
- Non-root Docker Container
- Kubernetes Network Policy
- Docker Image Vulnerability Scan (Trivy)

---

# 📈 Skills Demonstrated

- Cloud Engineering
- Google Cloud Platform
- Docker
- Kubernetes
- Infrastructure as Code
- Terraform
- CI/CD
- GitHub Actions
- IAM
- Workload Identity Federation
- Cloud Security
- Linux
- Nginx

---

# 👨‍💻 Author

**Islam Ahmad**

Cloud Engineer

GitHub:
https://github.com/Islam-Ahmad

Docker Hub:
https://hub.docker.com/r/islamahmad9/acme-web-design