pipeline {

  agent any

  environment {
    SVC_ACCOUNT_KEY = credentials('GKE-terraform')
    DOCKER_IMAGE_TAG = "eu.gcr.io/terraform-243812/hello-app:v${env.BUILD_ID}"
    GCR_PROJECT_ID  = "gcr:terraform-243812"
    PROJECT_ID =  "terraform-243812"
    GCLOUD_PATH =  "/opt/google-cloud-sdk/bin"
    CLUSTER_NAME = "cluster1"
    ZONE = "europe-west1"
    PORT = "8082"
    APP_NAME = "helloapp"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
        sh 'echo $SVC_ACCOUNT_KEY | base64 -d > gcpserviceaccount.json'
      }
    }


   stage('Build and push Docker image to GCR') {

      steps{
      
        script {
          docker.withRegistry('https://eu.gcr.io', GCR_PROJECT_ID)  {

          def customImage = docker.build(DOCKER_IMAGE_TAG)

          /* Push the container to the custom Registry */
          customImage.push()
        }
      }
     }
    }

    stage('TF Plan') {
      steps {
          sh 'terraform init'
          sh 'terraform plan -out myplan -lock=false -input=false'
      }      
    }

    stage('TF Apply') {
      steps {
          sh 'terraform apply  -input=false myplan'
      }
    }

    stage('Setup gloud access') {
            steps {

                // setup gcloud access and configuration
                sh '$GCLOUD_PATH/gcloud auth activate-service-account --key-file=gcpserviceaccount.json'
                sh '$GCLOUD_PATH/gcloud config set project $PROJECT_ID'
                sh '$GCLOUD_PATH/gcloud config set compute/zone europe-west1'
                sh '$GCLOUD_PATH/gcloud container images list-tags eu.gcr.io/terraform-243812/test-app'
                sh '$GCLOUD_PATH/gcloud container clusters --zone $ZONE get-credentials $CLUSTER_NAME'
            }
        }
        

    stage('Deploy Image to GKE Cluster') {
            steps {
                echo "Deploying the Docker image"
                sh '$GCLOUD_PATH/kubectl create $APP_NAME --image=$DOCKER_IMAGE_TAG --port $PORT'
                sh '$GCLOUD_PATH/kubectl get pods'
            }
        }
    } 
 } 