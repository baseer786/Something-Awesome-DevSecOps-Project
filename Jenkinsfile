pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'  // Jenkins credentials ID for Docker Hub
        DOCKER_USERNAME = 'baseerburney'                 // Docker Hub username
        KUBECONFIG_PATH = '/path/to/your/kubeconfig'     // Path for Kubernetes config if needed for `kubectl` commands
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/baseer786/Something-Awesome-DevSecOps-Project.git'
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
        stage('Security Scans') {
            parallel {
                stage('OWASP Dependency-Check') {
                    steps {
                        script {
                            docker.image('owasp/dependency-check').inside {
                                sh 'dependency-check.sh --project "User Service" --scan ./services/user-service'
                                sh 'dependency-check.sh --project "Order Service" --scan ./services/order-service'
                                sh 'dependency-check.sh --project "Product Service" --scan ./services/product-service'
                            }
                        }
                    }
                }
                stage('Snyk Scan') {
                    steps {
                        withCredentials([string(credentialsId: 'snyk-token', variable: 'SNYK_TOKEN')]) {
                            script {
                                docker.image('snyk/snyk-cli').inside {
                                    sh 'cd services/user-service && snyk test'
                                    sh 'cd services/order-service && snyk test'
                                    sh 'cd services/product-service && snyk test'
                                }
                            }
                        }
                    }
                }
                stage('SonarQube Analysis') {
                    steps {
                        withSonarQubeEnv('SonarQube') {
                            script {
                                docker.image('sonarsource/sonar-scanner-cli').inside {
                                    sh 'cd services/user-service && sonar-scanner'
                                    sh 'cd services/order-service && sonar-scanner'
                                    sh 'cd services/product-service && sonar-scanner'
                                }
                            }
                        }
                    }
                }
                stage('Gauntlt Security Tests') {
                    steps {
                        script {
                            docker.image('gauntlt/gauntlt').inside {
                                sh 'gauntlt attacks/*.attack'
                            }
                        }
                    }
                }
            }
        }
        stage('Build Docker Images') {
            steps {
                script {
                    docker.image('docker:latest').inside {
                        sh 'docker build -t baseerburney/user-service:latest ./services/user-service'
                        sh 'docker build -t baseerburney/order-service:latest ./services/order-service'
                        sh 'docker build -t baseerburney/product-service:latest ./services/product-service'
                    }
                }
            }
        }
        stage('Push Docker Images') {
            steps {
                withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                    script {
                        docker.image('docker:latest').inside {
                            sh 'echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin'
                            sh 'docker push baseerburney/user-service:latest'
                            sh 'docker push baseerburney/order-service:latest'
                            sh 'docker push baseerburney/product-service:latest'
                        }
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    docker.image('bitnami/kubectl:latest').inside {
                        sh 'kubectl apply -f kubernetes/deployment.yaml'
                    }
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
