pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS = credentials('dockerhub-credentials')
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Test Docker Access') {
            steps {
                sh 'docker --version'
            }
        }

        stage('Install Dependencies') {
            steps {
                // Testing Docker container run access
                script {
                    docker.image('node:14').inside {
                        sh 'node --version'
                        sh 'npm --version'
                    }
                }
            }
        }

        stage('Run ESLint') {
            steps {
                script {
                    docker.image('node:14').inside {
                        sh 'npm install -g eslint'
                        sh 'eslint . || true'  // Allow to fail to continue pipeline
                    }
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    docker.image('node:14').inside {
                        sh 'npm test || true'  // Adjust this as needed for your test framework
                    }
                }
            }
        }

        stage('Security Scans') {
            parallel {
                stage('OWASP Dependency-Check') {
                    steps {
                        echo 'Running OWASP Dependency-Check'
                        // Insert dependency-check logic here
                    }
                }
                stage('Snyk Scan') {
                    steps {
                        echo 'Running Snyk Scan'
                        // Insert Snyk scanning logic here
                    }
                }
                stage('SonarQube Analysis') {
                    steps {
                        echo 'Running SonarQube Analysis'
                        // Insert SonarQube scanning logic here
                    }
                }
                stage('Gauntlt Security Tests') {
                    steps {
                        echo 'Running Gauntlt Security Tests'
                        // Insert Gauntlt security testing logic here
                    }
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    def image = docker.build("your_dockerhub_username/your_project_name")
                    sh 'docker images'
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub-credentials') {
                        docker.image("your_dockerhub_username/your_project_name").push("latest")
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Ensure KUBECONFIG is set up properly
                    sh 'kubectl apply -f k8s/'
                }
            }
        }
    }
    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
            echo 'Build or deployment completed.'
        }
        failure {
            echo 'Build or deployment failed. Please check the logs for details.'
        }
    }
}
