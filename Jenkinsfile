pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'node:18'
    }
    stages {
        stage('Test Docker Access') {
            steps {
                sh 'docker --version'
            }
        }
        stage('Install Dependencies') {
            steps {
                // Pull and use node image to install dependencies
                sh 'docker pull ${DOCKER_IMAGE}'
                sh 'docker run --rm -v $(pwd):/app -w /app ${DOCKER_IMAGE} npm install'
            }
        }
        stage('Run ESLint') {
            steps {
                // Running ESLint checks
                sh 'docker run --rm -v $(pwd):/app -w /app ${DOCKER_IMAGE} npx eslint .'
            }
        }
        // Additional stages for testing, building, pushing images, etc.
    }
    post {
        always {
            cleanWs()
            echo 'Build or deployment failed. Please check the logs for details.'
        }
    }
}
