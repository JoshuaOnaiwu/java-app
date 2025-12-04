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

        
        //     environment {
        //         SONAR_TOKEN = credentials('sonarcloudinfo')
        //     }
        //     steps {
        //         withSonarQubeEnv('sonarqube') {
        //             sh """
        //                 ${SONAR_SCANNER}/bin/sonar-scanner \
        //                 -Dsonar.projectKey=my-java-app \
        //                 -Dsonar.sources=src \
        //                 -Dsonar.java.binaries=target \
        //                 -Dsonar.host.url=$SONARQUBE_URL \
        //                 -Dsonar.login=$SONAR_TOKEN
        //             """
        //         }
        stage('CompileandRunSonarAnalysis') {
            steps{
                withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_TOKEN')]) {
                    sh 'mvn clean verify sonar:sonar -Dsonar.login=$SONAR_TOKEN -Dsonar.organization=caleb-org -Dsonar.host.url=https://sonarcloud.io -Dsonar.projectKey=caleb-org_java-app' 
                }
            }
        }
        

        stage('Build Java Application') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Snyk Scan') {
            tools {
                jdk 'jdk17'
                maven 'maven3'
                }
            environment{
                SNYK_TOKEN = credentials('SNYK_TOKEN')
            }
            steps {
                dir("${WORKSPACE}"){
                sh """
                    ./mvnw dependency:tree -DoutputType=dot
                    snyk test --all-projects --severity-threshold=medium
                """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t amcal/my-java-app:v1 .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'DOCKER_LOGIN',
                    usernameVariable: 'USERNAME',
                    passwordVariable: 'PASSWORD'
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
            echo '✅ Build and Docker image-push successful'
        }
        failure {
            echo '❌ Build failed. Check the logs for details.'
        }
    }

}