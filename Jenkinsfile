pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/baseer786/Something-Awesome-DevSecOps-Project.git'
            }
        }

        stage('Install Dependencies') {
            parallel {
                stage('User Service Dependencies') {
                    steps {
                        sh 'cd services/user-service && npm install'
                    }
                }
                stage('Order Service Dependencies') {
                    steps {
                        sh 'cd services/order-service && npm install'
                    }
                }
                stage('Product Service Dependencies') {
                    steps {
                        sh 'cd services/product-service && npm install'
                    }
                }
            }
        }

        stage('Run ESLint') {
            parallel {
                stage('User Service ESLint') {
                    steps {
                        script {
                            try {
                                sh 'cd services/user-service && npx eslint .'
                            } catch (Exception e) {
                                echo "Lint errors in User Service, continuing..."
                            }
                        }
                    }
                }
                stage('Order Service ESLint') {
                    steps {
                        script {
                            try {
                                sh 'cd services/order-service && npx eslint .'
                            } catch (Exception e) {
                                echo "Lint errors in Order Service, continuing..."
                            }
                        }
                    }
                }
                stage('Product Service ESLint') {
                    steps {
                        script {
                            try {
                                sh 'cd services/product-service && npx eslint .'
                            } catch (Exception e) {
                                echo "Lint errors in Product Service, continuing..."
                            }
                        }
                    }
                }
            }
        }

        // Additional stages for testing, building, or deploying can be added here.
    }
}
