pipeline {
    agent any
    stages {
        stage('Verify Docker') {
            steps {
                sh 'docker --version'  // This checks Docker is available
            }
        }
        stage('Run Docker Hello World') {
            steps {
                sh 'docker run hello-world'  // This runs a test container
            }
        }
    }
}
