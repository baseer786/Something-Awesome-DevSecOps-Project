pipeline {
    agent any
    environment {
        PATH = "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
        KUBECONFIG = "/Users/baseerikram/.kube/config"
    }
    stages {
        stage('Test Docker Access') {
            steps {
                sh 'docker --version'
            }
        }
        stage('Install Dependencies') {
            steps {
                sh 'docker pull node:18'
                sh 'docker run --rm -v $PWD:/app node:18 npm install'
            }
        }
        stage('Run ESLint') {
            steps {
                sh 'docker run --rm -v $PWD:/app node:18 npx eslint .'
            }
        }
        stage('Run Tests') {
            steps {
                sh 'docker run --rm -v $PWD:/app node:18 npm test'
            }
        }
        stage('Build Docker Images') {
            steps {
                sh 'docker build -t baseerburney/product-service ./product-service'
                sh 'docker build -t baseerburney/order-service ./order-service'
                sh 'docker build -t baseerburney/user-service ./user-service'
            }
        }
        stage('Push Docker Images') {
            steps {
                withCredentials([string(credentialsId: 'DOCKER_CREDENTIALS', variable: 'DOCKER_PASSWORD')]) {
                    sh '''
                        echo $DOCKER_PASSWORD | docker login -u baseerburney --password-stdin
                        docker push baseerburney/product-service
                        docker push baseerburney/order-service
                        docker push baseerburney/user-service
                    '''
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f k8s/deployment.yaml'
                sh 'kubectl rollout status deployment/user-service-deployment'
                sh 'kubectl rollout status deployment/product-service-deployment'
                sh 'kubectl rollout status deployment/order-service-deployment'
            }
        }
    }
    post {
        always {
            cleanWs()
        }
        success {
            echo 'Build or deployment completed successfully.'
        }
        failure {
            echo 'Build or deployment failed. Please check the logs for details.'
        }
    }
}
