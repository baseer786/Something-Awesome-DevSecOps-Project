pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/baseer786/Something-Awesome-DevSecOps-Project.git'
            }
        }
        stage('Install Dependencies') {
            agent {
                docker { image 'node:14' } // Use Node.js 14 Docker image for npm
            }
            steps {
                sh 'cd services/user-service && npm install'
                sh 'cd services/order-service && npm install'
                sh 'cd services/product-service && npm install'
            }
        }
        stage('Run ESLint') {
            agent {
                docker { image 'node:14' }
            }
            steps {
                sh 'cd services/user-service && npm run lint'
                sh 'cd services/order-service && npm run lint'
                sh 'cd services/product-service && npm run lint'
            }
        }
        stage('Run Tests') {
            agent {
                docker { image 'node:14' }
            }
            steps {
                sh 'cd services/user-service && npm test'
                sh 'cd services/order-service && npm test'
                sh 'cd services/product-service && npm test'
            }
        }
        stage('Security Scans') {
            parallel {
                stage('OWASP Dependency-Check') {
                    agent {
                        docker { image 'owasp/dependency-check' }
                    }
                    steps {
                        sh 'dependency-check.sh --project "User Service" --scan ./services/user-service'
                        sh 'dependency-check.sh --project "Order Service" --scan ./services/order-service'
                        sh 'dependency-check.sh --project "Product Service" --scan ./services/product-service'
                    }
                }
                stage('Snyk Scan') {
                    agent {
                        docker { image 'snyk/snyk-cli' }
                    }
                    steps {
                        withCredentials([string(credentialsId: 'snyk-token', variable: 'SNYK_TOKEN')]) {
                            sh 'cd services/user-service && snyk test'
                            sh 'cd services/order-service && snyk test'
                            sh 'cd services/product-service && snyk test'
                        }
                    }
                }
                stage('SonarQube Analysis') {
                    agent {
                        docker { image 'sonarsource/sonar-scanner-cli' }
                    }
                    steps {
                        withSonarQubeEnv('SonarQube') {
                            sh 'cd services/user-service && sonar-scanner'
                            sh 'cd services/order-service && sonar-scanner'
                            sh 'cd services/product-service && sonar-scanner'
                        }
                    }
                }
                stage('Gauntlt Security Tests') {
                    agent {
                        docker { image 'gauntlt/gauntlt' }
                    }
                    steps {
                        sh 'gauntlt attacks/*.attack'
                    }
                }
            }
        }
        stage('Build Docker Images') {
            agent {
                docker { image 'docker:latest' }
            }
            steps {
                sh 'docker build -t baseerburney/user-service:latest ./services/user-service'
                sh 'docker build -t baseerburney/order-service:latest ./services/order-service'
                sh 'docker build -t baseerburney/product-service:latest ./services/product-service'
            }
        }
        stage('Push Docker Images') {
            agent {
                docker { image 'docker:latest' }
            }
            steps {
                withCredentials([string(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                    sh 'echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin'
                    sh 'docker push baseerburney/user-service:latest'
                    sh 'docker push baseerburney/order-service:latest'
                    sh 'docker push baseerburney/product-service:latest'
                }
            }
        }
        stage('Deploy to Kubernetes') {
            agent {
                docker { image 'bitnami/kubectl:latest' }
            }
            steps {
                sh 'ansible-playbook ansible/deploy.yml'
            }
        }
    }
    post {
        always {
            echo 'Cleaning up workspace and Docker images...'
            sh '''
                docker rmi baseerburney/user-service:latest || true
                docker rmi baseerburney/order-service:latest || true
                docker rmi baseerburney/product-service:latest || true
            '''
            cleanWs()
            echo 'Build complete.'
        }
    }
}

