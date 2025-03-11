pipeline {
    agent any

        // AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        // AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        // AWS_REGION = ${region}
        // S3_BUCKET = ${S3_BUCKET}
        // S3_KEY = ${S3_KEY}
    parameters{
        string(name: 'Repo_URL' , defaultValue: 'git@github.com:Zudypubg/Terraform-mock-project.git' , description: 'Git repository URL')
        string(name: 'S3_BUCKET', defaultValue: 'duy-mock-project', description: 'S3 bucket chứa terraform.tfvars')
        string(name: 'TFVARS_KEY', defaultValue: 'networking/terraform.tfvars', description: 'Key của file terraform.tfvars trên S3')

    }
    // // stage("Setup AWS Credentials") {
    //         steps {
    //             withCredentials([aws(credentialsId: 'GITHUB-PAT-FULL-ACCESS-3', region: "${region}")]) {  
    //                 script {
    //                     env.AWS_ACCESS_KEY_ID = env.AWS_ACCESS_KEY_ID
    //                     env.AWS_SECRET_ACCESS_KEY = env.AWS_SECRET_ACCESS_KEY
    //                 }
    //                 sh "aws sts get-caller-identity" 
    //             }
    //         }
    // }
    stages {
        stage('Checkout') {
            steps {
               git branch: "${region}",
                credentialsId: 'GITHUB-PAT-FULL-ACCESS',
                url: 'https://github.com/Zudypubg/Terraform-mock-project.git' 
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${work-directory}") {
                    script{
                        sh 'terraform init'
                    }
                    
                }
            }
        }
        stage("Load Terraform Variables") {
            steps {
                withCredentials([file(credentialsId: 'aws-credential', variable: 'TFVARS_FILE')]) {
                    script {
                        sh "cp -f ${TFVARS_FILE} ${work-directory}/terraform.tfvars"
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${work-directory}") {
                    script{
                        sh 'terraform plan -var-file="terraform.tfvars '
                    }
                    
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${work-directory}") {
                    script{
                        sh 'terraform apply -auto-approve -var-file="terraform.tfvars '
                    }
                    
                }
                
            }
        }
    }

    // post {
    //     always {
    //         sh 'terraform destroy -auto-approve'
    //     }
    // }
}
