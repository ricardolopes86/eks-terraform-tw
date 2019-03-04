# ThoughtWorks Infra Problem

The main goal of this project is to deploy an infrastructure in the Cloud - here we use AWS - to provision some infrastructure to deploy a set of microservices. The microservices are:
* Frontend application
* Newsfeed application
* Quotes application
* Static asset server

The infrastructure will be provisioned using AWS EKS for a faster Kubernetes cluster deployment.

## How this project is structured

Here you will find 2 Terraform modules: `eks-cluster` and `application`. The first one is intended to deploy the whole K8s cluster at EKS and the second should deploy the application.

### eks-cluster


### application

## How to use this project

### Initial setup

### Running the Terraform modules

## Challenges faced

## Design decisions