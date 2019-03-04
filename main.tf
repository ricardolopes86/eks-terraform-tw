module "eks-cluster" {
  source = "./eks-cluster"
  
}

module "application" {
  source = "./application"
  
}
