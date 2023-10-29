pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'us-east1-docker.pkg.dev/final-project-iti-hendawyy/my-images'
    }
    
    stages {
        stage('Connect to the cluster from the remote local private instance using IAP') {
            steps {
                sh 'echo "steps"'
                sh 'gcloud container clusters get-credentials gcp-k8s --zone europe-west1-b --project final-project-iti-hendawyy --internal-ip'
                sh 'gcloud compute ssh private-vm-instance --tunnel-through-iap --project=final-project-iti-hendawyy --zone=us-east1-b --ssh-flag="-4 -L8888:localhost:8888 -N -q -f"'
                sh 'export HTTPS_PROXY=localhost:8888'
                
            }
        }

        stage('Clone Repo') {
            steps {
                script {
                    checkout([$class: 'GitSCM', branches: [[name: '*/master']], userRemoteConfigs: [[url: 'https://github.com/Hendawyy/simple-node-app']]])
                }
            }
        }

        stage('Build and Tag Docker Image Frontend') {
            steps {
                sh 'docker build -t node-app:v1 .'
                sh "docker tag node-app:v1 $DOCKER_REGISTRY/node-app:v1"
            }
        }

        stage('Pull & Tag The MongoDB Image Backend') {
            steps {
                sh 'docker pull bitnami/mongodb:4.4.4'
                sh "docker tag bitnami/mongodb:4.4.4 $DOCKER_REGISTRY/mongodb:v1"
            }
        }

        stage('Configure Docker & Login') {  
            steps {
                script{

                def gcpCredentials = credentials('MyGoogleServiceAccountKey') 

                withCredentials([file(credentialsId: 'MyGoogleServiceAccountKey', variable: 'GCP_CREDENTIALS')]) {
                            
                    sh '''

                        cp \$GCP_CREDENTIALS svacckey.json

                        gcloud auth activate-service-account --key-file=${GCP_CREDENTIALS}

                        gcloud auth configure-docker us-east1-docker.pkg.dev

                        base64 -i svacckey.json > svacckeyz.json

                        ls

                        cat svacckeyz.json | docker login -u _json_key_base64 --password-stdin https://us-east1-docker.pkg.dev

                        gcloud container clusters update gcp-k8s --zone europe-west1-b --enable-master-global-access

                    '''
                }
            }
            }
        }

        stage('Push Docker Images to Artifact Registry') {
            steps {
            sh 'docker push $DOCKER_REGISTRY/node-app:v1'
            sh 'docker push $DOCKER_REGISTRY/mongodb:v1'
            }
        }

        stage('Deploy App on GKE') {
            steps {
                script {
                sh 'hostname -i'
                def gcpCredentials = credentials('MyGoogleServiceAccountKey') 

                withCredentials([file(credentialsId: 'MyGoogleServiceAccountKey', variable: 'GCP_CREDENTIALS')]) {
                            
                sh 'gcloud auth activate-service-account --key-file=${GCP_CREDENTIALS}'
                sh 'gcloud config set account seifhendawy1@gmail.com'
                sh 'gcloud auth activate-service-account final-project-iti-hendawyy-svc@final-project-iti-hendawyy.iam.gserviceaccount.com --key-file=${GCP_CREDENTIALS}'
                sh 'gcloud container clusters get-credentials gcp-k8s --zone europe-west1-b --project final-project-iti-hendawyy --internal-ip'
                sh 'gcloud compute ssh private-vm-instance --tunnel-through-iap --project=final-project-iti-hendawyy --zone=us-east1-b --ssh-flag="-4 -L8888:localhost:8888 -N -q -f"'
                sh 'export HTTPS_PROXY=localhost:8888'
                sh 'kubectl get ns'
                sh 'kubectl apply -f ../Terraform-Infrastructure-Action/Kubernetes/Mongo/'
                sh 'sleep 45'
                sh 'kubectl apply -f ../Terraform-Infrastructure-Action/Kubernetes/App/'
                sh 'kubectl get pods -n mongo -owide'
                sh 'kubectl get pods -n node -owide'
                    }
                }
            }
        }

    }
}