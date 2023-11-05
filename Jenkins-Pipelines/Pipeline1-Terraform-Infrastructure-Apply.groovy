pipeline {
    agent any

    parameters {
        choice(name: 'action', choices: ["Apply", "Destroy"], description: 'Select Terraform Action')
    }

    stages {
        stage('Access Remote Repo') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], userRemoteConfigs: [[url: 'https://github.com/Hendawyy/Final-Project-iti']]])
            }
        }

        
        stage('Terraform Init and Action') {
            steps {
                script {
                    def gcpCredentials = credentials('MyGoogleServiceAccountKey') 
                    if (gcpCredentials != null) {
                        withCredentials([file(credentialsId: 'MyGoogleServiceAccountKey', variable: 'GCP_CREDENTIALS')]) {
                            sh "mkdir -p Secrets"
                            sh "cp \$GCP_CREDENTIALS Secrets/final-project-iti-hendawyy-85436efc3b09.json"
                            sh("gcloud auth activate-service-account --key-file=${GCP_CREDENTIALS}")
                            sh 'ls'
                        }
                        
                        dir('Terraform') {
                            sh 'terraform init'
                            sh 'terraform plan'

                            def tfaction = params.action
                            if (tfaction == 'Apply') {
                                sh 'terraform apply -auto-approve'
                            } else if (tfaction == 'Destroy') {
                                sh 'terraform destroy -auto-approve'
                            } else {
                                error("Invalid choice for 'action' parameter")
                            }
                        }
                    } else {
                        error('Failed to obtain the Secret File credential')
                    }
                }
            }
        }
        
        stage('Trigger The Push & Deploy Pipeline') {
            steps {
                script{
                    def tfaction = params.action
                        if (tfaction == 'Apply') {
                            build job: 'Pipeline2-Push-and-Deploy'
                        } else if (tfaction == 'Destroy') {
                            sh 'echo "SUCCESS: All Resources Destroyed"'
                        } else {
                            error("Invalid choice for 'action' Parameter")
                        }
                }
            }
        }

    }
}
