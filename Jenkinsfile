pipeline {
    agent none

    options {
        skipDefaultCheckout(true)
    }

    environment {
        DOCKER_IMAGE = 'soumikroy2000/nodejs-assessment-app'
    }

    stages {

        stage('Checkout') {
            agent any
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            agent {
                docker {
                    image 'node:16-alpine'
                    reuseNode true
                }
            }
            steps {
                sh 'node --version'
                sh 'npm --version'
                sh 'npm ci'
            }
        }

        stage('Unit Tests') {
            agent {
                docker {
                    image 'node:16-alpine'
                    reuseNode true
                }
            }
            steps {
                sh 'npm test'
            }
        }

        stage('Security Scan') {
      agent {
        docker {
            image 'node:16-alpine'
            reuseNode true
        }
    }
      steps {
        sh 'npm audit --audit-level=high --json > npm-audit-report.json'
        archiveArtifacts artifacts: 'npm-audit-report.json,package.json,package-lock.json,Dockerfile,Jenkinsfile',
                         fingerprint: true
    }
 }
        stage('Build Docker Image') {
            agent any
            steps {
                sh '''
                    docker build \
                    -t ${DOCKER_IMAGE}:${BUILD_NUMBER} \
                    -t ${DOCKER_IMAGE}:latest .
                '''
            }
        }

        stage('Push Docker Image') {
            agent any
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKERHUB_USER',
                        passwordVariable: 'DOCKERHUB_TOKEN'
                    )
                ]) {
                    sh '''
                        echo "$DOCKERHUB_TOKEN" | \
                        docker login -u "$DOCKERHUB_USER" --password-stdin

                        docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
                        docker push ${DOCKER_IMAGE}:latest

                        docker logout
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'CI/CD pipeline completed successfully.'
        }

        failure {
            echo 'CI/CD pipeline failed. Check the stage logs.'
        }
    }
}
