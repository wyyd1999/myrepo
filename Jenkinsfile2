pipeline {
    agent none
    stages {
        stage('parallel checkout') {
            parallel {
                stage('checkout On cplus2 ') {
                    agent {
                        label "cplus2"
                    }
                    steps {
                        git branch: 'dev', url: 'git@bitbucket.org:shabodienggg/aep.git', credentialsId: 'build-server-master'
                    }
                }
                stage('checkout On java') {
                    agent {
                        label "java"
                    }
                    steps {
                        git branch: 'dev', url: 'git@bitbucket.org:shabodienggg/aep.git', credentialsId: 'build-server-master'
                    }
                }
            }
        }
        stage('laas analysing') {
            agent {label "java"}
            steps { 
            dir('laas') {
		        sh 'echo building in laas'
                sh 'sudo docker build -t 192.168.0.96:8083/laas:$(date +%F) .'
                withSonarQubeEnv('sonarqube') {sh 'mvn -B  clean verify sonar:sonar'}
                }
            }
            }
        stage('laas Quality Gate') {
            agent {label "java"}
            steps {
                withSonarQubeEnv('sonarqube') {
                timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
              }
            }
            }           
        }
        stage('snbp analysing') {
            agent {label "java"}
            steps { 
            dir('snbp') {
		        sh 'echo building in snbp'
                sh 'sudo docker build -t 192.168.0.96:8083/snbp:$(date +%F) .'
                withSonarQubeEnv('sonarqube') {sh 'mvn -B  clean verify sonar:sonar'}
                }
            }
            }
        stage('snbp Quality Gate') {
            agent {label "java"}
            steps {
                withSonarQubeEnv('sonarqube') {
                timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
              }
            }
            }           
        }
        stage('orchestrator analysing') {
            agent {label "java"}
            steps {
            dir('orchestrator') {
                sh'echo building in orchestrator'
                sh 'sudo docker build -t 192.168.0.96:8083/orchestrator:$(date +%F) .'
                withSonarQubeEnv('sonarqube') {sh 'mvn -B  clean verify sonar:sonar'}
                     }
                     }
                 }
        stage('orchestrator Quality Gate') {
            agent {label "java"}
            steps {
                withSonarQubeEnv('sonarqube') {
                timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
              }
            }
            }           
        }               
        stage('fm analysing') {
            agent {label "java"}
            steps {
            dir('fm') {
                sh'echo building in fm'
                sh 'sudo docker build -t 192.168.0.96:8083/fm:$(date +%F) .'
                withSonarQubeEnv('sonarqube') {sh 'mvn -B  clean verify sonar:sonar'}
                     }
                     }
                 }
        stage('fm Quality Gate') {
            agent {label "java"}
            steps {
                withSonarQubeEnv('sonarqube') {
                timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
              }
            }
            }           
        }
        stage('reference build') {
            agent {label "java"}
            steps {
            dir('reference') {
                sh'echo building in reference'
                sh 'sudo docker build -t 192.168.0.96:8083/reference:$(date +%F) .'
                     }
                     }
            }
        stage('insight analysing') {
            agent {label "java"}
            steps {
            dir('insight') {
                sh'echo building in insight'
                sh 'sudo docker build -t 192.168.0.96:8083/insight:$(date +%F) .'
                withSonarQubeEnv('sonarqube') {sh 'mvn -B  clean verify sonar:sonar'}
                     }
                     }
                 }
        stage('insight Quality Gate') {
            agent {label "java"}
            steps {
                withSonarQubeEnv('sonarqube') {
                timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
              }
            }
            }
        }
        stage('portal build') {
            agent {label "java"}
            environment {scannerHome = tool 'SonarQubeScanner'}
            steps {
            dir('portal/admin-ui') {
                sh'echo building in portal'
                sh 'yarn install'
                sh 'yarn test-coverage'
                withSonarQubeEnv('sonarqube') {sh "${scannerHome}/bin/sonar-scanner -D sonar.projectKey=portal-admin-ui -D sonar.sources=./src -D sonar.exclusions=**/*.test.tsx -D sonar.tests=./src -D sonar.test.inclusions=**/*.test.tsx,**/*.test.ts -D sonar.typescript.lcov.reportPaths=coverage/lcov.info" }
                archiveArtifacts artifacts: 'coverage/**', allowEmptyArchive: true
                     }
                     }
                 }
        stage('Quality Gate') {
            agent {label "java"}
            steps {
                withSonarQubeEnv('sonarqube') {
                timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
              }
            }
            }           
        } 
        stage('parallel build') {
            parallel {
                stage('mf build prod') {
                    agent {
                         label "cplus2"
                    }
                    steps {
                        dir('api-router') {
                             sh 'echo building in api-router'
                             sh 'sudo docker build --target mf_dev -f Dockerfile -t 192.168.0.96:8083/mf_dev_ci:$(date +%F) .'
                        }
                    }
                }               
                stage('ef build prod') {
                    agent {
                         label "cplus2"
                    }
                    steps {
                        dir('api-router') {
                             sh 'echo building in api-router'
                             sh 'sudo docker build --target ef_dev -f Dockerfile -t 192.168.0.96:8083/ef_dev_ci:$(date +%F) .'
                        }
                    }
                }                                      
            }
        }
    }
    post {
    failure {
      emailext (
          subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
          body: """<p>FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
            <p>Please check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
          to: 'engineer@shabodi.com'
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

