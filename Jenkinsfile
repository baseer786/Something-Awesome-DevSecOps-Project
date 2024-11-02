pipeline {
    agent any
    environment {
        DOCKER_CLI_PATH = '/usr/local/bin/docker'      // Explicit path to Docker CLI
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials' // Jenkins credentials ID for DockerHub
        DOCKER_USERNAME = 'baseerburney'                // DockerHub username
        KUBECONFIG_PATH = '/path/to/kubeconfig'         // Path to kubeconfig file
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Install Dependencies') {
            steps {
                script {
                    // Verify Docker accessibility
                    sh "${DOCKER_CLI_PATH} --version"
                    
                    docker.image('node:14').inside {
                        sh 'cd services/user-service && npm install'
                    }
                }
            }
        }
        stage('Run ESLint') {
            steps {
                script {
                    docker.image('node:14').inside {
                        sh 'cd services/user-service && npm run lint'
                    }
                }
            }
        }
        stage('Run Tests') {
            steps {
                script {
                    docker.image('node:14').inside {
                        sh 'cd services/user-service && npm test'
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
                                sh 'dependency-check --scan /path/to/scan --project MyProject'
                            }
                        }
                    }
                }
                stage('Snyk Scan') {
                    steps {
                        script {
                            docker.image('snyk/snyk-cli').inside {
                                sh 'snyk test'
                            }
                        }
                    }
                }
                stage('SonarQube Analysis') {
                    steps {
                        script {
                            docker.image('sonarsource/sonar-scanner-cli').inside {
                                sh 'sonar-scanner'
                            }
                        }
                    }
                }
                stage('Gauntlt Security Tests') {
                    steps {
                        script {
                            docker.image('gauntlt/gauntlt').inside {
                                sh 'gauntlt'
                            }
                        }
                    }
                }
            }
        }
        stage('Build Docker Images') {
            steps {
                script {
                    docker.build("${DOCKER_USERNAME}/user-service:latest", 'services/user-service')
                    docker.build("${DOCKER_USERNAME}/order-service:latest", 'services/order-service')
                    docker.build("${DOCKER_USERNAME}/product-service:latest", 'services/product-service')
                }
            }
        }
        stage('Push Docker Images') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    script {
                        sh "${DOCKER_CLI_PATH} login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                        
                        sh "${DOCKER_CLI_PATH} push ${DOCKER_USERNAME}/user-service:latest"
                        sh "${DOCKER_CLI_PATH} push ${DOCKER_USERNAME}/order-service:latest"
                        sh "${DOCKER_CLI_PATH} push ${DOCKER_USERNAME}/product-service:latest"
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                        sh "kubectl --kubeconfig=${KUBECONFIG} apply -f kubernetes/deployment.yaml"
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
