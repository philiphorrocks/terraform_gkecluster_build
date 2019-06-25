pipeline {

  agent any

  environment {
    SVC_ACCOUNT_KEY = credentials('GKE-terraform')
    DOCKER_IMAGE_TAG = "my-app:build-${env.BUILD_ID}"
    PROJECT_ID  = "terraform-243812"
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

          sh 'docker build -t gcr.io/${PROJECT_ID}/$DOCKER_IMAGE_TAG .'
          echo "List Docker imaage......"
          sh 'docker images'
          
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
        docker.withRegistry('https://gcr.io', 'gcr:google-gcr') {
            myContainer.push("gcr.io/${PROJECT_ID}/$DOCKER_IMAGE_TAG")
            myContainer.push("latest")
        }
    }

    stage('Deploy Image to GKE Cluster') {
            steps {
                echo "Deploying the Docker image"
            }
        }
    
    }}
