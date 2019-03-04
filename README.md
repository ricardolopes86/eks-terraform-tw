# ThoughtWorks Infra Problem

The main goal of this project is to deploy an infrastructure in the Cloud - here we use AWS - to provision some infrastructure to deploy a set of microservices. The microservices are:
* __Frontend__ application
* __Newsfeed__ application
* __Quotes__ application
* __Static__ asset server

The infrastructure will be provisioned using AWS EKS for a faster Kubernetes (k8s for short) cluster deployment.

## How this project is structured

Here you will find 2 Terraform modules: `eks-cluster` and `application`. The first one is intended to deploy the whole K8s cluster at EKS and the second should deploy the application.

### eks-cluster


### application

## How to use this project

### Initial setup

### Running the Terraform modules

### How to update the applications

The update process is quite straight forward. As we're working with K8s, we're working with Docker images that will be deployed as deployments. A deployment is a set of objects in k8s lingo. One of these objects is a pod, nothing but a Docker container running and image.  
Therefore, in order to rollout a new version of the application, the developer should build a new image and push it to the Docker Hub or a private Docker Registry if this is the case.  
The steps necessary to update the image are these:
1. Create or copy the Dockerfile (it needs to have this name, with capital D or you name it as you wish and use -f flag and give the name of the custom Dockerfile) from the `dockerfiles` directory in this repository, the one corresponding to the microservice that is going to be updated. Place this Dockerfile in the root of your microservice folder i.e frontend, newsfeed, quotes or static;
2. Once the Dockerfile is in place, run the following command in order to get the image:  
```bash
docker build . -t username/imagename:0.2
```  
Where:  
`username` - is the name of the developer repository   
`imagename` - the image name  
`0.2` - its the tag for versioning your image.  

3. When Docker finishes the build, its time to push it to the Docker Hub, follow the steps below to accomplish this:  
Login to Docker Hub from the command line by issuing:
```bash
docker login
```  
Provide your login information. After logging in, just push the new image to the command:  
```bash
docker push username/imagename:0.2
```
4. Now its time to update the Terraform deployment manifesto by changing the image name in the file `application/deployments.yml`. Change the image value at line 27 to the newer image.
5. Finally apply the changes to the cluster by running:
```bash
terraform plan -out deployment.plan && terraform apply
```
This will trigger the redeployment of the Docker image containing the newer version of the application.
## Challenges faced

## Design decisions
