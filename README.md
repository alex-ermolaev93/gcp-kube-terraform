# Kubernetes Engine and Helm 
## Requirements

Before this module can be used on a project, you must ensure that the following pre-requisites are fulfilled:

1. Terraform and kubectl are [installed](#software-dependencies) on the machine where Terraform is executed.
2. The Service Account you execute the module with has the right [permissions](#configure-a-service-account).
3. The Compute Engine and Kubernetes Engine APIs are [active](#enable-apis) on the project you will launch the cluster in.
4. If you are using a Shared VPC, the APIs must also be activated on the Shared VPC host project and your service account needs the proper permissions there.

The [project factory](https://github.com/terraform-google-modules/terraform-google-project-factory) can be used to provision projects with the correct APIs active and the necessary Shared VPC connections.

### Software Dependencies
#### Kubectl
- [kubectl](https://github.com/kubernetes/kubernetes/releases)
#### Terraform and Plugins
- [Terraform](https://www.terraform.io/downloads)
- [Terraform Provider for GCP][terraform-provider-google] 
#### httpie
- [httpie](https://httpie.io/docs/cli/debian-and-ubuntu)
#### Helm
- [Helm](https://helm.sh/docs/intro/install/)

#### Gcloud
Some submodules use the [terraform-google-gcloud](https://github.com/terraform-google-modules/terraform-google-gcloud) module. By default, this module assumes you already have gcloud installed in your $PATH.
See the [module](https://github.com/terraform-google-modules/terraform-google-gcloud#downloading) documentation for more information.

### Configure a Service Account
In order to execute this module you must have a Service Account with the
following project roles:
- roles/compute.viewer
- roles/compute.securityAdmin (only required if `add_cluster_firewall_rules` is set to `true`)
- roles/container.clusterAdmin
- roles/container.developer
- roles/iam.serviceAccountAdmin
- roles/iam.serviceAccountUser
- roles/resourcemanager.projectIamAdmin (only required if `service_account` is set to `create`)

Additionally, if `service_account` is set to `create` and `grant_registry_access` is requested, the service account requires the following role on the `registry_project_ids` projects:
- roles/resourcemanager.projectIamAdmin

### Enable APIs
In order to operate with the Service Account you must activate the following APIs on the project where the Service Account was created:

- Compute Engine API - compute.googleapis.com
- Kubernetes Engine API - container.googleapis.com

[terraform-provider-google]: https://github.com/terraform-providers/terraform-provider-google
[12.3.0]: https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/12.3.0
[terraform-0.13-upgrade]: https://www.terraform.io/upgrade-guides/0-13.html


## Enable service management API

This example creates a Cloud Endpoints service and requires that the Service Manangement API is enabled.
- Enable the Service Management API:

```bash
gcloud services enable servicemanagement.googleapis.com cloudapis.googleapis.com compute.googleapis.com container.googleapis.com

gcloud auth list 
gcloud container clusters list
gcloud config set project <project_name>
```    
##  Terraform

## Inputs(terraform.tfvars)

```
project              = "<change>" # project name  
region               = "europe-west1" #
location             = "europe-west1-b"
gcp_auth_file        = "./files/<change>.json" # Service accaunt key
network\_name        = "tf-gce-helm" # Network name
app_name             = "<change>" # Name for your app
registry\_username   = "<change>" # User name Dockerhub
registry\_password   = "<change>" # pass Dockerhub
registry\_email      = "<change>@gmail.com" # Mail DockerHub
registry\_server     = "docker.io" # -
```
<!-- do not understand what this is about -->
Then perform the following commands on the root folder:

- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure


## Testing
- Install  `network-multitool` for tests
```bash
kubectl create deployment multitool --image=praqma/network-multitool
```
- Prerequisites

## Add a public ip address for the necessary resources such as:

| Name | port |
|------|--------|
| grafana         |`:3000`|
| prometheus-server |`:9090`|

### Gcloud console > Kubernetes engine > (choose your cluster) >

### `Workloads`

| Name | Status | Type       |
|------|--------|------------|
| nginx | OK | Deployment |


**Actions** > 
Expose Port mapping  - ``Port1 80`` / ``Target port1 80`` (expose)

### `Services & Ingress`

| Name                                | Status | Type                    |Endpoints |
|-------------------------------------|--------|-------------------------|-----------|
| nginx | OK     | 	External load balancer | ``http://<IP>:80`` |


## Connecting with kubectl and helm
- Get the cluster credentials and configure kubectl:
```bash
gcloud container clusters list
gcloud container clusters get-credentials <cluster_name> --region  europe-west1-b
```
### Helm
## charts(files/**/values.yaml)
```
helm list
helm upgrade --install -f app/values.yaml app ./app
helm uninstall <chart(nginx)>
```

### Monitoring
- Grafana
  Login to grafana and add dashboards 


  - login: `admin`
  - password: `strongpassword`(change)

[Loki Logs with quicksearch](https://grafana.com/grafana/dashboards/13359-logs/) 13359

```./files/grafana/dashboards/```
- Prometheus

### 