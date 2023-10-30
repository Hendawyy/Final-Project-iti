pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'us-east1-docker.pkg.dev/final-project-iti-hendawyy/my-images'
    }
    
    stages {

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

        stage('Upload App on Private VM') {
            steps {
                sh 'sudo tar -czvf /tmp/Kubernetes.tar.gz -C /home/seif/Documents/Projects/Final_Project/Final-Project-iti/ Kubernetes'
                sh 'gcloud compute scp --project=final-project-iti-hendawyy --zone=us-east1-b /tmp/Kubernetes.tar.gz seif@private-vm-instance:/home/seif/Kubernetes.tar.gz --tunnel-through-iap'
                sh 'rm -rf /tmp/Kubernetes.tar.gz'
                }
            }

        stage('Deploy App on GKE') {
    steps {
        script {
            def sshCommand = """
                gcloud compute ssh private-vm-instance --project=final-project-iti-hendawyy --zone=us-east1-b --tunnel-through-iap <<EOF
                ls
                sudo tar -xzvf /home/seif/Kubernetes.tar.gz -C /home/seif/
                sudo rm -rf /home/seif/Kubernetes.tar.gz
                gcloud container clusters get-credentials gcp-k8s --zone europe-west1-b --project final-project-iti-hendawyy --internal-ip
                kubectl get ns
                kubectl apply -f /home/seif/Kubernetes/Mongo/
                sleep 45
                kubectl apply -f /home/seif/Kubernetes/App/
                sleep 10
                kubectl get nodes
                kubectl get pods -n mongo -owide
                kubectl get pods -n node -owide
EOF
            """
            sh sshCommand
        }
    }
}

    }
}