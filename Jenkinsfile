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
          
