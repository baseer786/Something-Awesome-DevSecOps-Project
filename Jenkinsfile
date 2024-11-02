pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS = credentials('dockerhub-credentials') // Make sure this ID matches in Jenkins
        KUBECONFIG = '/Users/baseerikram/.kube/config' // Path to your kubeconfig file on the Jenkins server
    }
    stages {
        stage('Checkout') {
            steps {
                // Clone repository
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
                        script {
                            // OWASP Dependency-Check commands go here
                            echo 'Running OWASP Dependency-Check...'
                        }
                    }
                }
                stage('Snyk Scan') {
                    steps {
                        script {
                            // Snyk scan commands go here
                            echo 'Running Snyk Scan...'
                        }
                    }
                }
                stage('SonarQube Analysis') {
                    steps {
                        script {
                            // SonarQube analysis commands go here
                            echo 'Running SonarQube Analysis...'
                        }
                    }
                }
                stage('Gauntlt Security Tests') {
                    steps {
                        script {
                            // Gauntlt security test commands go here
                            echo 'Running Gauntlt Security Tests...'
                        }
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
                 
