pipeline {
    agent any
    environment { 
        buildid = "${env.BUILD_ID}"
        buildnumber = "${env.BUILD_NUMBER}"
        buildtag = "${env.BUILD_TAG}"
    }
    stages {
        stage('checkout') {
             steps {
                git branch: 'main', url: 'https://github.com/wyyd1999/myrepo.git'
            }
        }
        stage('Build') {
            steps {
                sh 'echo ${buildid}'
                sh 'echo ${buildnumber}'
                sh 'echo ${buildtag}'

                sh 'make clean && make'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
                sh 'make test'
            }
        }
        stage('Deploy') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS'
              }
            }
            steps {
                sh 'docker build -t hello_world_app .'
            }
        }
    }
}
