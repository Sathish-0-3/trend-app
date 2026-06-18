## Project Overview

This project demonstrates the complete deployment of a production-ready React application using modern DevOps practices.

The application is containerized using Docker, infrastructure is provisioned using Terraform, deployed to Amazon EKS through Jenkins CI/CD, and monitored using Prometheus and Grafana.

# Technologies Used

- React (Production Build)
- Docker
- Docker Hub
- Terraform
- AWS EC2
- AWS IAM
- Amazon EKS
- Kubernetes
- Jenkins
- GitHub
- Prometheus
- Grafana
- AWS Network Load Balancer (NLB)

# Project Architecture

GitHub Repository
        │
        ▼
 GitHub Webhook
        │
        ▼
     Jenkins
        │
 ┌──────┴─────────┐
 │                │
 ▼                ▼
Docker Build   Docker Push
                    │
                    ▼
               Docker Hub
                    │
                    ▼
             Kubernetes (EKS)
                    │
             Deployment & Service
                    │
                    ▼
      AWS Network Load Balancer
                    │
                    ▼
               End Users

Monitoring:

Prometheus -----> Grafana

# Project Structure

trend-app/
│
├── Dockerfile
├── Jenkinsfile
├── deployment.yaml
├── service.yaml
├── .dockerignore
├── .gitignore
├── README.md
│
└── terraform/
      ├── main.tf
      └── outputs.tf

# Setup Instructions

## Step 1 - Clone Repository

git clone https://github.com/Vennilavanguvi/Trend.git

cd trend-app

## Step 2 - Build Docker Image

docker build -t trend-app .

Verify image

docker images

## Step 3 - Push Image to Docker Hub

docker tag trend-app sathishbalaji03/trend-app:latest

docker push sathishbalaji03/trend-app:latest

## Step 4 - Provision Infrastructure

Initialize Terraform

terraform init

Plan Infrastructure

terraform plan

Create Infrastructure

terraform apply

Resources Created

- VPC
- Internet Gateway
- Public Subnet
- Route Table
- Security Group
- IAM Role
- EC2 Instance

## Step 5 - Install Jenkins

Install Jenkins on EC2.

Install plugins

- Docker
- Git
- Pipeline
- Kubernetes
- Docker Pipeline


## Step 6 - Create Amazon EKS Cluster

eksctl create cluster \
--name trend-cluster1 \
--region ap-south-1 \
--nodegroup-name workers \
--node-type t3.small \
--nodes 2

Verify

kubectl get nodes

## Step 7 - Deploy Application

kubectl apply -f deployment.yaml

kubectl apply -f service.yaml

Verify

kubectl get pods

kubectl get svc

## Step 8 - Install AWS Load Balancer Controller

Install

- IAM Policy
- OIDC Provider
- Helm Chart

Verify

kubectl get deployment -n kube-system aws-load-balancer-controller

## Step 9 - Install Prometheus & Grafana

helm install monitoring prometheus-community/kube-prometheus-stack

Verify

kubectl get pods
## Step 10 - Access Application

Application URL

http://k8s-default-trendser-b160924a03-88dfdc8cf4a697ba.elb.ap-south-1.amazonaws.com/

## Step 11 - Access Grafana

http://a906a036c45684e5099df35e1520dfab-1055800361.ap-south-1.elb.amazonaws.com

# CI/CD Pipeline Explanation

The Jenkins Declarative Pipeline automates the complete deployment process.

### Stage 1 - Checkout

- Pulls the latest code from GitHub.

### Stage 2 - Build Docker Image

- Builds a Docker image using the Dockerfile.

Command executed

docker build

### Stage 3 - Push Docker Image

- Logs into Docker Hub.
- Pushes the Docker image.

Commands executed

docker push

### Stage 4 - Deploy to Kubernetes

Deploys the application to Amazon EKS using

kubectl apply -f deployment.yaml

kubectl apply -f service.yaml


### Stage 5 - Verification

Kubernetes automatically creates

- Deployment
- ReplicaSet
- Pods
- Service
- Network Load Balancer


# Monitoring

Monitoring is implemented using

- Prometheus
- Grafana

Metrics collected

- CPU Usage
- Memory Usage
- Network Usage
- Pod Status
- Node Status
- Cluster Health

# Docker Hub Repository

https://hub.docker.com/r/sathishbalaji03/trend-app

# GitHub Repository
https://github.com/Sathish-0-3/trend-app

# Outcome

Successfully deployed a production-ready React application using Docker, Terraform, Jenkins, Amazon EKS, Kubernetes, AWS Network Load Balancer, Prometheus, and Grafana with an automated CI/CD pipeline.