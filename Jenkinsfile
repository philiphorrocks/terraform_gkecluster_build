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
    
    stage('Build and push Docker image to GCR') {

      steps{
      
        script {
          docker.withRegistry('','gcr[PROJECT_ID]')  {

          def customImage = docker.build(PROJECT_ID  + ":$BUILD_NUMBER")

          /* Push the container to the custom Registry */
          customImage.push()
        }
      }
    }
    }

    stage('Deploy Image to GKE Cluster') {
            steps {
                echo "Deploying the Docker image"
            }
        }
  } 
 }