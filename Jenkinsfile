pipeline {
    agent any

    stages {
        stage('Build Docker Images') {
            steps {
                script {
                    // Building Docker images for each service
                    sh 'docker build -t baseerburney/user-service:latest ./services/user-service'
                    sh 'docker build -t baseerburney/order-service:latest ./services/order-service'
                    sh 'docker build -t baseerburney/product-service:latest ./services/product-service'
                }
            }
        }
        stage('Push Docker Images') {
            steps {
                script {
                    // Logging into Docker Hub and pushing images
                    sh 'echo $DOCKER_HUB_PASS | docker login --username baseerburney --password-stdin'
                    sh 'docker push baseerburney/user-service:latest'
                    sh 'docker push baseerburney/order-service:latest'
                    sh 'docker push baseerburney/product-service:latest'
                }
            }
        }
        stage('Lint with ESLint') {
            steps {
                script {
                    // Running ESLint in each service directory
                    sh 'cd services/user-service && npx eslint .'
                    sh 'cd services/order-service && npx eslint .'
                    sh 'cd services/product-service && npx eslint .'
                }
            }
        }
    }
}
