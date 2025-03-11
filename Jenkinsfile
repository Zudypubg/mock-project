pipeline {
    agent any

     environment {
        GITHUB_PAT = credentials('GitHub-PAT-Full-Access-4')

        // Sử dụng Jenkins Credentials để lấy AWS credentials
        AWS_ACCESS_KEY_ID = credentials('AWS-Access-Key-ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS-Secret-Access-Key')
        AWS_DEFAULT_REGION = 'sa-east-1'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout([$class: 'GitSCM', 
                              branches: [[name: '*/main']], 
                              userRemoteConfigs: [[url: 'https://github.com/Zudypubg/mock-project.git', 
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