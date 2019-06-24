pipeline {

  agent any

  environment {
    SVC_ACCOUNT_KEY = credentials('GKE-terraform')
    DOCKER_IMAGE_TAG = "my-app:build-${env.BUILD_ID}"
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
                    docker_image = docker.build("${env.DOCKER_IMAGE_TAG}", '-f ./Dockerfile .')
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
    
    stage('Push Docker image to Repository') {
            steps {
                echo "Pushing the Docker image to the registry"
            }
        }
        stage('Deploy Image to GKE Cluster') {
            steps {
                echo "Deploying the Docker image"
            }
        }
    
    }}
