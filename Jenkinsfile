pipeline {
    agent {
        label 'agent'
    }

    

    environment {
        // Sử dụng Jenkins Credentials để lấy GitHub PAT
        GITHUB_PAT = credentials('GitHub-PAT-Full-Access-5')

        // Sử dụng Jenkins Credentials để lấy AWS credentials
        AWS_ACCESS_KEY_ID = credentials('AWS-Access-Key-ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS-Secret-Access-Key')
        AWS_DEFAULT_REGION = 'ap-southeast-1'

        // Work directory
        WORK_DIR = "environments/dev"
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout([$class: 'GitSCM', 
                              branches: [[name: '*/main']], 
                              userRemoteConfigs: [[url: "https://${GITHUB_PAT}@github.com/Zudypubg/mock-project.git"]]])
                }
            }
        }
    
        stage('Check AWS CLI') {
            steps {
                sh 'export PATH=$PATH:/usr/local/bin && aws --version'
            }
        }
    
        stage('Download terraform.tfvars from S3') {
            steps {
                script {
                    // Tải file terraform.tfvars từ S3 bucket
                    sh """
                        aws s3 cp s3://duy-s3-bucket-project/networking/terraform.tfvars ${WORK_DIR}/terraform.tfvars
                    """
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    dir(WORK_DIR) {
                        sh """
                            terraform init
                        """
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    dir(WORK_DIR) {
                        sh """
                            terraform plan -out=tfplan -lock=false
                        """
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    dir(WORK_DIR) {
                        sh """
                            terraform apply -lock=false -auto-approve tfplan 
                        """
                    }
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