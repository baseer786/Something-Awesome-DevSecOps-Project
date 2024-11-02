pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS = credentials('dockerhub-credentials') // Use your Jenkins credentials ID for Docker
        KUBECONFIG = '/Users/baseerikram/.kube/config' // Replace with the path to kubeconfig if different
    }
    stages {
        stage('Checkout') {
            steps {
                // Clone the repository
                git branch: 'main', url: 'https://github.com/baseer786/Something-Awesome-DevSecOps-Project.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    docker.image('node:14').inside {
                        sh 'npm install'
                    }
                }
            }
        }

        stage('Run ESLint') {
            steps {
                script {
                    docker.image('node:14').inside {
                        sh 'npx eslint .'
                    }
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    docker.image('node:14').inside {
                        sh 'npm test'
                    }
                }
            }
        }

        stage('Security Scans') {
            parallel {
                stage('OWASP Dependency-Check') {
                    steps {
                        echo 'Running OWASP Dependency-Check...'
                        // Add OWASP commands here
                    }
                }
                stage('Snyk Scan') {
                    steps {
                        echo 'Running Snyk Scan...'
                        // Add Snyk scan commands here
                    }
                }
                stage('SonarQube Analysis') {
                    steps {
                        echo 'Running SonarQube Analysis...'
                        // Add SonarQube commands here
                    }
                }
                stage('Gauntlt Security Tests') {
                    steps {
                        echo 'Running Gauntlt Security Tests...'
                        // Add Gauntlt commands here
                    }
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS) {
                        def appImage = docker.build("baseerburney/myapp:${env.BUILD_ID}")
                        appImage.push()
                    }
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS) {
                        def appImage = docker.image("baseerburney/myapp:${env.BUILD_ID}")
                        appImage.push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withEnv(["KUBECONFIG=${KUBECONFIG}"]) {
                        sh 'kubectl apply -f k8s/deployment.yaml'
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
        success {
            echo 'Build and deployment completed successfully.'
        }
        failure {
            echo 'Build or deployment failed. Please check the logs for details.'
        }
    }
}
