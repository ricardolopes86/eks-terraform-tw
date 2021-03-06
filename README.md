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
The structure of this module is composed by:  
`eks-cluster.tf` - configure the EKS cluster;  
`eks-worker-nodes.tf` - configure the worker nodes;  
`outputs.tf` - will print out the configuration of the kubeconfig file together with the iam-was-authenticator;   
`providers.tf` - the configuration related to the Cloud provider, in our example it is AWS;   
`variables.tf` - all variables used in the files in order to simplify the referrences;  
`vpc.tf` - configure the necessary VPC (Virtual Private Cloud) to our k8s cluster;  
`workstation-external-ip.tf` - in order to be able to run kubectl commands, this file will add the proper configuration to allow outbound connections.   
This code was **explicitly copied** from the working example at the Terraform [github](https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples/eks-getting-started) page. I just changed to reflect my configurations.


### application
The structure of this module is composed by:  
`deployments.tf` - The k8s deployments configuration is here;  
`provider.tf` - here we have the configuration for the k8s provider for this module;  
`variables.tf` - and the variables used accross this module.

## How to use this project

### Initial setup
1. Your AWS credentials should be stored at the `~/.aws/credentials`. You can choose to create it manually or you can install `awscli` from `pip`, run the command `aws configure` and answer the questions to properly configure this file;
2. The IAM Role defined with proper accesses. For simplicity purposes, I decided to use my root AWS account with `Admin` rights in order to avoid any further issues with IAM Roles;
3. Terraform installed;
4. (Optional) The microservices should be built in your machine. In order to build it, follow the steps in this [git repository section](https://github.com/ThoughtWorksInc/infra-problem#building);
5. (Optional) Once you build, copy each artifact to the proper microservice folder, it should be at the same level as your Dockerfile;

### Running the Terraform modules
To deploy the k8s cluster together with the application deployments, you should follow the very straight forward steps:
* cd to the terraform folder where you will find the `main.tf` file that will trigger the subsequent modules;
* Run the command `terraform init` followed by `terraform plan -out yourfile.plan`. These commands will initiate the Terraform and will check the state of your infrastructure against the manifestos contained in this folder. At your first run, it will not find any terraform state file to compare with your Cloud infrastructure;
* Run `terraform apply` to have your k8s cluster deployed and then your applications rolledout in the next step, be aware that initial setup will take several minutes (something between 10min to 15min).

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
Provide your login information. After logging in, just push the new image to the Docker Hub with the command:  
```bash
docker push username/imagename:0.2
```
4. Now its time to update the Terraform deployment manifesto by changing the image name in the file `application/deployments.tf`. Change the image value at line 27 to the newer image.
5. Finally apply the changes to the cluster by running:
```bash
terraform plan -out deployment.plan && terraform apply
```
This will trigger the redeployment of the Docker image containing the newer version of the application.
## Challenges faced
* First and most pleasent was the lack of knowledge in Kubernetes, which I'd tried to learn in less than 3 days. Loved this part of this challenge;
* Initially I've built a set of EC2 instances in order to then, deploy the Kubernetes cluster. With almost zero experience with k8s, this seemed to be a stupid decision after a few hours trying to find the proper solution, then I decided to use AWS EKS due to it's "simplicity" to deploy a self-managed k8s cluster;
* Properly inject the needed environment variables into the `frontend` microservice as the k8s cluster would spin the deployments by its own dynamic configuration. Then after some search in Google, I figured out the k8s way to do it by using `ConfigMap`.