pipeline {
    agent any
    environment {
        DOCKER_HUB_USERNAME = 'baseerburney'  // Your Docker Hub username
    }
    stages {
        stage('Lint') {
            steps {
                dir('path_to_user_service_directory') {
                    sh 'npm install'
                    sh 'npx eslint .'
                }
                dir('path_to_order_service_directory') {
                    sh 'npm install'
                    sh 'npx eslint .'
                }
                dir('path_to_product_service_directory') {
                    sh 'npm install'
                    sh 'npx eslint .'
                }
            }
        }
        stage('Build Docker Images') {
            steps {
                script {
                    docker.build("baseerburney/user-service:latest", './path_to_user_service_directory')
                    docker.build("baseerburney/order-service:latest", './path_to_order_service_directory')
                    docker.build("baseerburney/product-service:latest", './path_to_product_service_directory')
                }
            }
        }
        stage('Push Docker Images') {
            steps {
                docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                    sh "docker push baseerburney/user-service:latest"
                    sh "docker push baseerburney/order-service:latest"
                    sh "docker push baseerburney/product-service:latest"
                }
            }
        }
        // Include other stages here if necessary, such as testing or deploying.
    }
}
