pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials' // Using your Jenkins DockerHub credentials ID
        DOCKER_USERNAME = 'baseerburney'
        SNYK_TOKEN = credentials('snyk_api_token') // Snyk API Token from Jenkins credentials
        PATH = "/usr/local/bin:$PATH" // Adding Ansible to PATH
    }
    stages {
        stage('Declarative: Checkout SCM') {
            steps {
                checkout scm
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

        stage('Run Snyk Test') {
            steps {
                script {
                    def services = ['user-service', 'order-service', 'product-service']
                    services.each { service ->
                        dir("services/${service}") {
                            sh 'npm install -g snyk'  // Install Snyk CLI
                            sh 'snyk auth ${SNYK_TOKEN}' // Authenticate with Snyk
                            sh 'snyk test' // Run Snyk test on the codebase
                        }
                    }
                }
            }
        }

        stage('Run Snyk Monitor') {
            steps {
                script {
                    def services = ['user-service', 'order-service', 'product-service']
                    services.each { service ->
                        dir("services/${service}") {
                            sh 'snyk monitor'  // Send results to Snyk dashboard
                        }
                    }
                }
            }
        }

        stage('OWASP Dependency-Check') {
            steps {
                script {
                    def services = ['user-service', 'order-service', 'product-service']
                    services.each { service ->
                        dir("services/${service}") {
                            sh '$(brew --prefix dependency-check)/bin/dependency-check --project "${service}" --scan . --format ALL --out ./dependency-check-report --nvdApiKey 581c658a-1edf-40a7-aa4b-b5772a7699cd'
                            sh 'mkdir -p ../../owasp-reports/${service}'
                            sh 'mv ./dependency-check-report/* ../../owasp-reports/${service}/'
                        }
                    }
                }
                echo 'OWASP Dependency-Check reports can be retrieved from the owasp-reports folder in the Jenkins workspace.'
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
                    echo 'You can access the Kubernetes dashboard by running: minikube dashboard'
                }
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
            echo 'Note: Snyk vulnerabilities report can be accessed at https://app.snyk.io after the pipeline completes.'
            cleanWs()
        }
    }
}
