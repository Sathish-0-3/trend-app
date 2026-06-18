pipeline {

    agent any

    environment {

        IMAGE_NAME = "sathishbalaji03/trend-app"

        DOCKER_CREDENTIALS = "dockerhub"

    }

    stages {

        stage('Checkout') {

            steps {

                git branch: 'main',
                    url: 'https://github.com/Sathish-0-3/trend-app.git'

            }

        }

        stage('Build Docker Image') {

            steps {

                sh '''
                docker build -t $IMAGE_NAME:$BUILD_NUMBER .
                docker tag $IMAGE_NAME:$BUILD_NUMBER $IMAGE_NAME:latest
                '''

            }

        }

        stage('Push to DockerHub') {

            steps {

                withDockerRegistry([credentialsId: DOCKER_CREDENTIALS]) {

                    sh '''
                    docker push $IMAGE_NAME:$BUILD_NUMBER
                    docker push $IMAGE_NAME:latest
                    '''

                }

            }

        }

        stage('Deploy to Kubernetes') {

            steps {

                sh '''
                kubectl apply -f deployment.yaml
                kubectl apply -f service.yaml
                '''

            }

        }

    }

    post {

        success {

            echo 'Application deployed successfully.'

        }

        failure {

            echo 'Pipeline failed.'

        }

    }

}