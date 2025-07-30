pipeline {
  agent any
  environment {
    DOCKER_REGISTRY = 'Anki15201' // Replace with your Docker Hub username
    DOCKER_CREDENTIALS = credentials('docker-credentials') // Jenkins credential ID for Docker Hub
    KUBE_CONFIG = credentials('kubeconfig') // Jenkins credential ID for Kubernetes config
  }
  stages {
    stage('Checkout') {
      steps {
        echo 'Checking out code from GitHub...'
        git branch: 'main', url: 'https://github.com/Anki15201/microservices-shop.git'
      }
    }
    stage('Build Docker Images') {
      steps {
        script {
          def services = ['adservice', 'cartservice', 'checkoutservice', 'currencyservice', 'emailservice', 'frontend', 'paymentservice', 'productcatalogservice', 'recommendationservice', 'shippingservice']
          for (service in services) {
            dir(service) {
              echo "Building Docker image for ${service}..."
              sh "docker build -t ${DOCKER_REGISTRY}/microservices:${service} ."
            }
          }
        }
      }
    }
    stage('Push Docker Images') {
      steps {
        script {
          docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS) {
            def services = ['adservice', 'cartservice', 'checkoutservice', 'currencyservice', 'emailservice', 'frontend', 'paymentservice', 'productcatalogservice', 'recommendationservice', 'shippingservice']
            for (service in services) {
              echo "Pushing Docker image for ${service}..."
              sh "docker push ${DOCKER_REGISTRY}/microservices:${service}"
            }
          }
        }
      }
    }
    stage('Deploy to Kubernetes') {
      steps {
        script {
          echo 'Deploying to Kubernetes using Helm...'
          // Use kubeconfig for Kubernetes access
          withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
            dir('kubernetes-helm') {
              sh 'helmfile apply'
            }
          }
        }
      }
    }
  }
  post {
    success {
      echo 'Pipeline completed successfully!'
    }
    failure {
      echo 'Pipeline failed. Check logs for details.'
    }
    always {
      echo 'Cleaning up workspace...'
      cleanWs() // Clean workspace to free up space
    }
  }
}