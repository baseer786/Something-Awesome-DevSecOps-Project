pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials' // Jenkins DockerHub credentials ID
        DOCKER_USERNAME = 'baseerburney'
        OWASP_REPORT_DIR = "${WORKSPACE}/owasp-reports"
        PATH = "/usr/local/bin:$PATH"  // Adding Ansible to PATH
    }
    stages {
        stage('Declarative: Checkout SCM') {
            steps {
                checkout scm
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

        stage('OWASP Dependency-Check') {
            steps {
                script {
                    sh "mkdir -p ${env.OWASP_REPORT_DIR}"
                }
                dir('services/user-service') {
                    sh '$(brew --prefix dependency-check)/bin/dependency-check --project "User Service" --scan . --format ALL --out ./dependency-check-report --nvdApiKey 581c658a-1edf-40a7-aa4b-b5772a7699cd'
                    sh "mv ./dependency-check-report/* ${env.OWASP_REPORT_DIR}/user-service/"
                }
                dir('services/order-service') {
                    sh '$(brew --prefix dependency-check)/bin/dependency-check --project "Order Service" --scan . --format ALL --out ./dependency-check-report --nvdApiKey 581c658a-1edf-40a7-aa4b-b5772a7699cd'
                    sh "mv ./dependency-check-report/* ${env.OWASP_REPORT_DIR}/order-service/"
                }
                dir('services/product-service') {
                    sh '$(brew --prefix dependency-check)/bin/dependency-check --project "Product Service" --scan . --format ALL --out ./dependency-check-report --nvdApiKey 581c658a-1edf-40a7-aa4b-b5772a7699cd'
                    sh "mv ./dependency-check-report/* ${env.OWASP_REPORT_DIR}/product-service/"
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
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh '''
                    echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                    docker push baseerburney/user-service:latest
                    docker push baseerburney/order-service:latest
                    docker push baseerburney/product-service:latest
                    docker logout
                    '''
                }
            }
        }

        stage('Setup Ansible') {
            steps {
                script {
                    echo 'Activating virtual environment at /Users/baseerikram/venvs/ansible-env'
                    sh '''
                    source /Users/baseerikram/venvs/ansible-env/bin/activate
                    ansible-galaxy collection install kubernetes.core
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    echo 'Activating virtual environment at /Users/baseerikram/venvs/ansible-env for deployment'
                    sh '''
                    source /Users/baseerikram/venvs/ansible-env/bin/activate
                    ansible-playbook -i ansible/inventory ansible/deploy.yml --connection=local
                    '''
                }
            }
        }

        stage('Run Kubernetes Dashboard') {
            steps {
                echo 'Starting Kubernetes Dashboard...'
                sh 'minikube dashboard --url &'
            }
        }

        stage('Kubernetes Health Checks') {
            steps {
                echo 'Running Kubernetes Health Checks...'
                sh '''
                kubectl get deployments
                kubectl get pods
                kubectl get services
                kubectl describe deployments
                kubectl describe pods
                kubectl describe services
                # Get logs for all running pods
                for pod in $(kubectl get pods -o=name); do
                    kubectl logs $pod
                done
                '''
            }
        }

        stage('Declarative: Post Actions') {
            steps {
                echo 'Cleaning up...'
                sh '''
                docker logout || true
                if [ -n "$VIRTUAL_ENV" ]; then
                    deactivate || true
                fi
                '''
            }
        }
    }
    post {
        always {
            echo 'Pipeline finished. Cleaning workspace.'
            sh "echo 'OWASP Reports are saved in ${env.OWASP_REPORT_DIR}'"
            cleanWs()
        }
    }
}
