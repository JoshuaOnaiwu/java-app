pipeline {
    agent any

    tools {
        maven 'maven3'
        jdk 'jdk17'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
                
        stage('Build Java Application') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
    }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t amcal/my-java-app:v1 .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withcredentials([usernamePassword(
                    credentialsId: "DOCKER_LOGIN",
                    usernameVariable: 'USERNAME',
                    passwordvariable: 'PASSWORD'
                )]) {
                    sh '''
                        echo $PASSWORD | docker login -u $USERNAME --password-stdin
                        docker push amcal/my-java-app:v1
                        docker logout
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅Pipeline completed successfully'
        }
        failure {
            echo '❌Build failed. Check the logs for details.'
        }
    }

}
