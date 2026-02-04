pipeline {
    agent any

    stages {
        stage('Checkout Source') {
            steps {
                echo 'Checking out code...'
                checkout scm
            }
        }

        stage('Build Java Application') {
            steps {
                echo 'Building Java app...'
                sh 'javac Main.java' // ← swap with your actual build command
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t your-dockerhub-username/java-app:latest .' // update registry/tag
            }
        }

        stage('Push Docker Image') {
            steps {
                echo 'Pushing Docker image...'
                sh 'docker push your-dockerhub-username/java-app:latest' // update registry/tag
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs.'
        }
    }
}
