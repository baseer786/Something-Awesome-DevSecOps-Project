pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'
        KUBECONFIG_CREDENTIALS_ID = 'kubeconfig'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/baseer786/Something-Awesome-DevSecOps-Project.git'
            }
        }

        stage('Install Dependencies') {
            agent {
                docker { image 'node:14' }
            }
            steps {
                script {
                    sh 'npm install'
                }
            }
        }

        stage('Run ESLint') {
            agent {
                docker { image 'node:14' }
            }
            steps {
                script {
                    sh 'npx eslint .'
                }
            }
        }

        stage('Run Tests') {
            agent {
                docker { image 'node:14' }
            }
            steps {
                script {
                    sh 'npm test'
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    docker.build("baseerburney/user-service:latest", "./services/user-service")
                    docker.build("baseerburney/order-service:latest", "./services/order-service")
                    docker.build("baseerburney/product-service:latest", "./services/product-service")
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh """
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                        docker push baseerburney/user-service:latest
                        docker push baseerburney/order-service:latest
                        docker push baseerburney/product-service:latest
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: "${KUBECONFIG_CREDENTIALS_ID}", variable: 'KUBECONFIG')]) {
                    sh '''
                        kubectl apply -f k8s/user-deployment.yaml
                        kubectl apply -f k8s/order-deployment.yaml
                        kubectl apply -f k8s/product-deployment.yaml
                    '''
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
