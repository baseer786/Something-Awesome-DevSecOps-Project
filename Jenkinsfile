pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = "baseerburney"  // Replace with your Docker Hub username
        DOCKER_CREDENTIALS_ID = "dockerhub-credentials"  // Jenkins credentials ID for Docker Hub
        SNYK_TOKEN_CREDENTIALS_ID = "snyk-token"  // Jenkins credentials ID for Snyk token
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/baseer786/Something-Awesome-DevSecOps-Project.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'cd services/user-service && npm install'
                sh 'cd services/order-service && npm install'
                sh 'cd services/product-service && npm install'
            }
        }

        stage('Run ESLint') {
            steps {
                sh 'cd services/user-service && npm run lint'
                sh 'cd services/order-service && npm run lint'
                sh 'cd services/product-service && npm run lint'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'cd services/user-service && npm test'
                sh 'cd services/order-service && npm test'
                sh 'cd services/product-service && npm test'
            }
        }

        stage('Security Scans') {
            parallel {
                stage('OWASP Dependency-Check') {
                    steps {
                        sh 'dependency-check.sh --project "User Service" --scan ./services/user-service'
                        sh 'dependency-check.sh --project "Order Service" --scan ./services/order-service'
                        sh 'dependency-check.sh --project "Product Service" --scan ./services/product-service'
                    }
                }
                stage('Snyk Scan') {
                    steps {
                        withCredentials([string(credentialsId: SNYK_TOKEN_CREDENTIALS_ID, variable: 'SNYK_TOKEN')]) {
                            sh 'cd services/user-service && snyk test'
                            sh 'cd services/order-service && snyk test'
                            sh 'cd services/product-service && snyk test'
                        }
                    }
                }
                stage('SonarQube Analysis') {
                    steps {
                        withSonarQubeEnv('SonarQube') { // Configure your SonarQube server in Jenkins
                            sh 'cd services/user-service && sonar-scanner'
                            sh 'cd services/order-service && sonar-scanner'
                            sh 'cd services/product-service && sonar-scanner'
                        }
                    }
                }
                stage('Gauntlt Security Tests') {
                    steps {
                        sh 'gem install gauntlt'
                        sh 'gauntlt attacks/*.attack'
                    }
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                sh 'docker build -t ${DOCKER_HUB_REPO}/user-service:latest ./services/user-service'
                sh 'docker build -t ${DOCKER_HUB_REPO}/order-service:latest ./services/order-service'
                sh 'docker build -t ${DOCKER_HUB_REPO}/product-service:latest ./services/product-service'
            }
        }

        stage('Push Docker Images') {
            steps {
                withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                    sh 'docker push ${DOCKER_HUB_REPO}/user-service:latest'
                    sh 'docker push ${DOCKER_HUB_REPO}/order-service:latest'
                    sh 'docker push ${DOCKER_HUB_REPO}/product-service:latest'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'ansible-playbook ansible/deploy.yml'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace and Docker images...'
            sh 'docker rmi ${DOCKER_HUB_REPO}/user-service:latest || true'
            sh 'docker rmi ${DOCKER_HUB_REPO}/order-service:latest || true'
            sh 'docker rmi ${DOCKER_HUB_REPO}/product-service:latest || true'
            cleanWs()
        }
        failure {
            echo 'Build failed. Please check the error logs.'
        }
    }
}
