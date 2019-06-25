pipeline {

  agent any

  environment {
    SVC_ACCOUNT_KEY = credentials('GKE-terraform')
    DOCKER_IMAGE_TAG = "my-app:build-${env.BUILD_ID}"
    PROJECT_ID  = "terraform-243812"
    REGISTRY = "eu.gcr.io"
    REGISTRYCRED = 'google-gcr'

  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
        sh 'echo $SVC_ACCOUNT_KEY | base64 -d > gcpserviceaccount.json'
      }
    }

    stage('Build Immutable Docker Image') {
      steps {
          
        script {
          docker.build REGISTRY  + PROJECT_ID:"$BUILD_NUMBER"
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
    
    stage('Push images') {
      steps{
        echo "Push images to GCR"
           // docker.withRegistry('https://eu.gcr.io', 'gcr:google-gcr') {
            //myContainer.push(gcr.io/${PROJECT_ID}/$DOCKER_IMAGE_TAG)
            //myContainer.push("latest")
        }
      }
    
    
    stage('Deploy Image to GKE Cluster') {
            steps {
                echo "Deploying the Docker image"
            }
        }
  } 
}