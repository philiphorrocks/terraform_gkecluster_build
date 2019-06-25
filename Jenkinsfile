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

    //stage('Build Immutable Docker Image') {
    // steps {
    //      
    //    script {
    //      docker.build(PROJECT_ID  + ":$BUILD_NUMBER")
    //       }
    //  }
    //}

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
    
    stage('Push image to GCS') {

      steps{
      
        script {
          docker.withRegistry('https://eu.gcr.io', SVC_ACCOUNT_KEY) {

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