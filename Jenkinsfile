pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/baseer786/Something-Awesome-DevSecOps-Project.git'
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    // Building Docker images for each service
                    docker.build("baseerburney/user-service:latest", './services/user-service')
                    docker.build("baseerburney/order-service:latest", './services/order-service')
                    docker.build("baseerburney/product-service:latest", './services/product-service')
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                script {
                    // Logging in to Docker Hub and pushing images using the correct credentials ID
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        sh "docker push baseerburney/user-service:latest"
                        sh "docker push baseerburney/order-service:latest"
                        sh "docker push baseerburney/product-service:latest"
                    }
                }
            }
        }

        stage('Lint with ESLint') {
            steps {
                script {
                    // Running ESLint for each service
                    dir('services/user-service') {
                        sh "npx eslint ."
                    }
                    dir('services/order-service') {
                        sh "npx eslint ."
                    }
                    dir('services/product-service') {
                        sh "npx eslint ."
                    }
                }
            }
        }

        // Additional stages can be added here if needed.
    }
}
