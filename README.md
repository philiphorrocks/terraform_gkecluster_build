# terraform_gkecluster_build
Terraform gke cluster build 

Terraform scrtipt to build out GKE cluster. 

How to use:

1) Create new Jenkins pipeline
2) Configure the SCM job to use the Jenkinsfile provided in the reposittory

Pre-requisite

You must create your Google account and anable access to the API

Setup Jenkins Credentials
Go back to your jenkins service, and make sure login with an admin account. Choose “Credentials” from the sidebar, then choose “Global credentials” (you can choose other domains as well), and click “Add Credentials”.

Select “Google Service Account from private key” for the “Kind” field, and enter your project name ( myregistry in this example). Then upload the JSON private key we just downloaded in previous step.


