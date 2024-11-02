pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS = credentials('dockerhub-credentials')
        KUBECONFIG = '/Users/baseerikram/.kube/config' // Update this path if necessary
    }
    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout scm
                }
            }
        }
        
        stage('Test Docker Access') {
            steps {
                sh 'docker --version'
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
                        script {
                            docker.image('owasp/dependency-check').inside {
                                sh 'dependency-check.sh --project YourProject --scan .'
                            }
                        }
                    }
                }
                
                stage('Snyk Scan') {
                    steps {
                        script {
                            docker.image('snyk/snyk-cli').inside {
                                withCredentials([string(credentialsId: 'snyk-token', variable: 'SNYK_TOKEN')]) {
                                    sh 'snyk test'
                                }
                            }
                        }
                    }
                }
                
                stage('SonarQube Analysis') {
                    steps {
                        script {
                            withSonarQubeEnv('SonarQube') {
                                sh 'mvn sonar:sonar'
                            }
                        }
                    }
                }
                
                stage('Gauntlt Security Tests') {
                    steps {
                        script {
                            docker.image('gauntlt/gauntlt').inside {
                                sh 'gauntlt attack'
                            }
                        }
                    }
                }
            }
        }
        
        stage('Build Docker Images') {
            steps {
                script {
                    docker.build("baseerburney/${env.PROJECT_NAME}-service")
                }
            }
        }
        
        stage('Push Docker Images') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        sh 'docker push baseerburney/${env.PROJECT_NAME}-service'
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withEnv(["KUBECONFIG=${env.KUBECONFIG}"]) {
                        sh '''
                        kubectl apply -f kubernetes/deployment.yaml
                        kubectl apply -f kubernetes/service.yaml
                        '''
                    }
                }
            }
        }
    }
    post {
        always {
            cleanWs()
            echo 'Build or deployment completed. Check logs for details.'
        }
        failure {
            echo 'Build or deployment failed. Please check the logs for details.'
        }
    }
}
