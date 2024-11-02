pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/baseer786/Something-Awesome-DevSecOps-Project.git'
            }
        }

        stage('Check Environment') {
            steps {
                echo "Checking environment settings..."
                sh 'echo Current PATH: $PATH'
                sh 'which ansible'
            }
        }

        stage('Install Dependencies') {
            parallel {
                stage('User Service Dependencies') {
                    steps {
                        dir('services/user-service') {
                            sh 'npm install'
                        }
                    }
                }
                stage('Order Service Dependencies') {
                    steps {
                        dir('services/order-service') {
                            sh 'npm install'
                        }
                    }
                }
                stage('Product Service Dependencies') {
                    steps {
                        dir('services/product-service') {
                            sh 'npm install'
                        }
                    }
                }
            }
        }

        stage('Run ESLint') {
            parallel {
                stage('User Service ESLint') {
                    steps {
                        dir('services/user-service') {
                            sh 'npx eslint . || echo "Lint errors in User Service, continuing..."'
                        }
                    }
                }
                stage('Order Service ESLint') {
                    steps {
                        dir('services/order-service') {
                            sh 'npx eslint . || echo "Lint errors in Order Service, continuing..."'
                        }
                    }
                }
                stage('Product Service ESLint') {
                    steps {
                        dir('services/product-service') {
                            sh 'npx eslint . || echo "Lint errors in Product Service, continuing..."'
                        }
                    }
                }
            }
        }

        stage('Run Tests') {
            parallel {
                stage('User Service Tests') {
                    steps {
                        dir('services/user-service') {
                            sh 'npm test'
                        }
                    }
                }
                stage('Order Service Tests') {
                    steps {
                        dir('services/order-service') {
                            sh 'npm test'
                        }
                    }
                }
                stage('Product Service Tests') {
                    steps {
                        dir('services/product-service') {
                            sh 'npm test'
                        }
                    }
                }
            }
        }

        stage('Build Docker Images') {
            parallel {
                stage('User Service Docker Build') {
                    steps {
                        dir('services/user-service') {
                            sh 'docker build -t baseerburney/user-service:latest .'
                        }
                    }
                }
                stage('Order Service Docker Build') {
                    steps {
                        dir('services/order-service') {
                            sh 'docker build -t baseerburney/order-service:latest .'
                        }
                    }
                }
                stage('Product Service Docker Build') {
                    steps {
                        dir('services/product-service') {
                            sh 'docker build -t baseerburney/product-service:latest .'
                        }
                    }
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                    sh 'echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin'
                    sh 'docker push baseerburney/user-service:latest'
                    sh 'docker push baseerburney/order-service:latest'
                    sh 'docker push baseerburney/product-service:latest'
                }
            }
        }

        stage('Setup Ansible') {
            steps {
                sh 'ansible-galaxy collection install kubernetes.core'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'ansible-playbook ansible/deploy.yml'
            }
        }
    }
}
