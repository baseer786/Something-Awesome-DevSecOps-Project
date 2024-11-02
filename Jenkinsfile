pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials' // Replace with the actual credentials ID in Jenkins
        DOCKER_USERNAME = 'baseerburney'
        KUBECONFIG_PATH = '/path/to/kubeconfig' // Set the actual kubeconfig path if needed
    }
    stages {
        stage('Checkout') {
            steps {
                // Clones the repo to the Jenkins workspace
                git branch: 'main', url: 'https://github.com/baseer786/Something-Awesome-DevSecOps-Project.git'
            }
        }
        
        stage('Install Dependencies') {
            steps {
                script {
                    docker.image('node:14').inside {
                        sh 'cd services/user-service && npm install'
                        sh 'cd services/order-service && npm install'
                        sh 'cd services/product-service && npm install'
                    }
                }
            }
        }
        
        stage('Run ESLint') {
            steps {
                script {
                    docker.image('node:14').inside {
                        sh 'cd services/user-service && npm run lint'
                        sh 'cd services/order-service && npm run lint'
                        sh 'cd services/product-service && npm run lint'
                    }
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                script {
                    docker.image('node:14').inside {
                        sh 'cd services/user-service && npm test'
                        sh 'cd services/order-service && npm test'
                        sh 'cd services/product-service && npm test'
                    }
                }
            }
        }
        
        stage('Build Docker Images') {
            steps {
                script {
                    docker.withRegistry('', DOCKER_CREDENTIALS_ID) {
                        sh "docker build -t ${DOCKER_USERNAME}/user-service:latest ./services/user-service"
                        sh "docker build -t ${DOCKER_USERNAME}/order-service:latest ./services/order-service"
                        sh "docker build -t ${DOCKER_USERNAME}/product-service:latest ./services/product-service"
                    }
                }
            }
        }
        
        stage('Push Docker Images') {
            steps {
                script {
                    docker.withRegistry('', DOCKER_CREDENTIALS_ID) {
                        sh "docker push ${DOCKER_USERNAME}/user-service:latest"
                        sh "docker push ${DOCKER_USERNAME}/order-service:latest"
                        sh "docker push ${DOCKER_USERNAME}/product-service:latest"
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // You may need to replace this with kubectl commands based on your setup
                    sh "kubectl --kubeconfig=${KUBECONFIG_PATH} apply -f deployment.yml"
                }
            }
        }
    }
    
    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
            echo 'Build complete.'
        }
    }
}
