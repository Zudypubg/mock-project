pipeline {
    agent any

     environment {
    //     AWS_ACCESS_KEY_ID = ${Access_Key}''
    //     AWS_SECRET_ACCESS_KEY = ${AWS_SECRET_ACCESS_KEY}''
    //     AWS_DEFAULT_REGION = ${region}'sa-east-1'
        GITHUB_CREDENTIALS = credentials('GitHub-PAT-Full-Access-4')
    //     S3_BUCKET = ${s3}'duy-mock-project'
    //     TERRAFORM_TFVARS_PATH = ${Path}'networking/terraform.tfvars'
     }

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout([$class: 'GitSCM', 
                              branches: [[name: '*/main']], 
                              userRemoteConfigs: [[url: 'https://github.com/Zudypubg/Terraform-mock-project.git', 
                                                  credentialsId: 'GitHub-PAT-Full-Access-4']]])
                }
            }
        }

        stage('Download terraform.tfvars from S3') {
            steps {
                script {
                    sh """
                        aws s3 cp s3://${S3_BUCKET}/${TERRAFORM_TFVARS_PATH} ./terraform.tfvars
                    """
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh """
                        terraform init
                    """
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    sh """
                        terraform plan -out=tfplan
                    """
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    sh """
                        terraform apply -auto-approve tfplan
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Terraform apply completed successfully!'
        }
        failure {
            echo 'Terraform apply failed!'
        }
    }
}