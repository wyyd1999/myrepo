pipeline {
    agent any
    environment { 
        buildid = "${env.BUILD_ID}"
        buildnumber = "${env.BUILD_NUMBER}"
        buildtag = "${env.BUILD_TAG}"
        COMMON_CREDS = credentials('NEXUS_COMMON_CREDS')
    }
    stages {
        stage('checkout') {
             steps {
                git branch: 'dev2', url: 'https://github.com/wyyd1999/myrepo.git'
            }
        }
        stage('Build') {
            steps {
                sh 'echo ${buildid}'
                sh 'echo ${buildnumber}'
                sh 'echo ${buildtag}'

                sh 'docker build -t localhost:8082/repository/dockerhosted-repo/nginx:${buildid} .'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS'
              }
            }
            steps {
                sh 'docker login localhost:8082 --username ${COMMON_CREDS_USR} --password ${COMMON_CREDS_PSW}'
                sh 'docker push localhost:8082/repository/dockerhosted-repo/nginx:${buildid}'
            }
        }
    }
}

