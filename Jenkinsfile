#!groovy
def kuberemote = [:]
kuberemote.name = 'test'
kuberemote.host = '172.25.200.70'		
kuberemote.allowAnyHosts = true
		
pipeline {
    agent any
    environment {
        IMAGE_NAME = "dotnet-core-demo" // The name you want to give your docker image. Ex. git-migrator                
		DOCKER_HUB_REPO = "hpatani/docker-demo-hub"
		
    }
    options {
        skipDefaultCheckout true
    }
    
    stages {
        stage('Pull Repository') {
            agent any
            steps {
                script {
                    def gitRepoUrl = scm.getUserRemoteConfigs()[0].getUrl()
                    checkout scm: [$class: 'GitSCM', branches: scm.branches, extensions: scm.extensions, gitTool: 'Linux-Git Path', userRemoteConfigs: [[credentialsId: 'harshalgitcred', name: 'origin', url: gitRepoUrl]]]                    
                }
            }
        }

        stage('Create Image') {
            agent any
            steps {
                script {                        
					withCredentials([usernamePassword(credentialsId: 'harshalgitcred', usernameVariable: 'docker_username', passwordVariable: 'docker_password')]) {
						env.IMAGE_TAG = "latest"
						sh "docker login -u $docker_username -p $docker_password"
						sh "docker build -f Dockerfile . -t ${env.IMAGE_NAME}"
						sh "docker tag ${env.IMAGE_NAME} ${env.DOCKER_HUB_REPO}:${env.IMAGE_TAG}"
						sh "docker push ${env.DOCKER_HUB_REPO}:${env.IMAGE_TAG}"																
					}
				}
			}
        }
		
		stage('Copy Deployment File') {
			agent any
			steps {
				script {
					withCredentials([usernamePassword(credentialsId: 'Kube-Creds', usernameVariable: 'kube_username', passwordVariable: 'kube_password')]) {
						sh "sshpass -p ${kube_password} scp deployment.yml  ${kube_username}@172.25.200.70:/home/${kube_username}/deployments"
					}
				}
			}
		}
		
		stage('Deploy Container') {
			agent any
			steps {
				script {
					withCredentials([usernamePassword(credentialsId: 'Kube-Creds', usernameVariable: 'kube_username', passwordVariable: 'kube_password')]) {
						kuberemote.user = kube_username
						kuberemote.password = kube_password					
						sshCommand remote: kuberemote, sudo: true, command: "kubectl create -f /home/${kube_username}/deployments/deployment.yml"					
					}
				}
			}
		}
    }
}
