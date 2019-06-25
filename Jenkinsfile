pipeline {

  agent any

  environment {
    SVC_ACCOUNT_KEY = credentials('GKE-terraform')
    DOCKER_IMAGE_TAG = "eu.gcr.io/terraform-243812/build:${env.BUILD_ID}"
    GCR_PROJECT_ID  = "gcr:terraform-243812"
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
          docker.withRegistry('https://eu.gcr.io/terraform-243812', GCR_PROJECT_ID)  {

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

    stage('Deploy Image to GKE Cluster') {
            steps {
                echo "Deploying the Docker image"
            }
        }
    } 
 } 