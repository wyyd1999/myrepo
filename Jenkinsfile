pipeline {
    agent any
    stages {
	stage('checkout') {
	     steps {
		git branch: 'dev2', url: 'https://github.com/wyyd1999/myrepo.git'
		}
	}
	stage('build'){
	    steps {
		sh 'docker build -t localhost:8082/repository/dockerhosted-repo/nginx:0.0.2'
		}
  	}
        stage('build') {
            steps {
                sh 'docker login localhost:8082 --username admin --password abc123'
		sh 'docker push localhost:8082/repository/dockerhosted-repo/nginx:0.0.2'
            }
        }
    }
}
