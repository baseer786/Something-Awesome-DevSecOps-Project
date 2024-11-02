pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        VIRTUAL_ENV = '/Users/baseerikram/venvs/ansible-env'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/baseer786/Something-Awesome-DevSecOps-Project.git', branch: 'main'
            }
        }

        stage('Check Environment') {
            steps {
                echo 'Checking environment settings...'
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
                            sh 'npx eslint .'
                        }
                    }
                }
                stage('Order Service ESLint') {
                    steps {
                        dir('services/order-service') {
                            sh 'npx eslint .'
                        }
                    }
                }
                stage('Product Service ESLint') {
                    steps {
                        dir('services/product-service') {
                            sh 'npx eslint .'
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
                withCredentials([string(credentialsId: 'dockerhub-credentials', variable: 'DOCKERHUB_PASSWORD')]) {
                    sh '''
                        echo $DOCKERHUB_PASSWORD | docker login -u baseerburney --password-stdin

                        docker push baseerburney/user-service:latest
                        docker push baseerburney/order-service:latest
                        docker push baseerburney/product-service:latest
                    '''
                }
            }
        }

        stage('Setup Ansible') {
            steps {
                script {
                    echo "Activating virtual environment at $VIRTUAL_ENV"
                    sh """
                        source $VIRTUAL_ENV/bin/activate
                        ansible-galaxy collection install kubernetes.core
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            timeout(time: 10, unit: 'MINUTES') {
                steps {
                    script {
                        echo "Activating virtual environment at $VIRTUAL_ENV for deployment"
                        sh """
                            source $VIRTUAL_ENV/bin/activate
                            ansible localhost -m ping -i ansible/inventory
                            ansible-playbook -i ansible/inventory ansible/deploy.yml -e ansible_connection=local --timeout=30
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            sh 'docker logout'
            sh 'deactivate || true'
        }
        failure {
            echo 'Deployment failed. Please check the logs.'
        }
    }
}
