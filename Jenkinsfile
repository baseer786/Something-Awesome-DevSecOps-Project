pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/baseer786/Something-Awesome-DevSecOps-Project.git'
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
    }
}
