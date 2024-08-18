pipeline {
    agent any
    triggers {
        cron('H 23 * * *')
    }
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
        stage('BuildDocker') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS'
              }
            }
            steps {
                sh 'docker build -t wyyd1999/hello_world_app:latest .'
            }
        }
        stage('PushDocker') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS'
              }
            }
            steps {
                sh 'docker push wyyd1999/hello_world_app:latest'
            }
        }
        stage('DeployDocker') {
            steps {
                sh 'docker pull wyyd1999/hello_world_app:latest'
                sh 'docker rm -f hello_world_container'
                sh 'docker run -d --name hello_world_container wyyd1999/hello_world_app:latest'
            }
        }
    }
    post {
    failure {
      emailext (
          subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
          body: """<p>FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
            <p>Please check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
          to: 'wyyd1999@gmail.com'
        )
        bitbucketStatusNotify(
                buildState: 'FAILED',
                repoSlug: 'aep',
                commitId: env.GIT_COMMIT
        )
    }
    success {
        bitbucketStatusNotify(
                buildState: 'SUCCESSFUL',
                repoSlug: 'aep',
                commitId: env.GIT_COMMIT
        )
        }
  }
}
