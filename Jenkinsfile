pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        AWS_DEFAULT_REGION    = "us-east-1"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Get Public IP') {
            steps {
                script {
                    env.EC2_IP = sh(
                        script: "cd terraform && terraform output -raw public_ip",
                        returnStdout: true
                    ).trim()
                }
            }
        }

        stage('Deploy Nginx') {
            steps {
                script {
                    // Use the Jenkins credential for the SSH private key
                    withCredentials([sshUserPrivateKey(credentialsId: 'jenkins-ssh', keyFileVariable: 'SSH_KEY')]) {

                        // Create dynamic Ansible inventory
                        sh """
                        echo "[web]" > ansible/inventory
                        echo "\$EC2_IP ansible_user=ubuntu ansible_ssh_private_key_file=\$SSH_KEY ansible_python_interpreter=/usr/bin/python3" >> ansible/inventory

                        // Run Ansible playbook
                        ansible-playbook -i ansible/inventory ansible/install_nginx.yml
                        """
                    }
                }
            }
        }
    }
}
