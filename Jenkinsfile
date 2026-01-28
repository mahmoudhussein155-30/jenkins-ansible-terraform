pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "us-east-1"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Debug Files') {
            steps {
                sh 'ls -R'
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
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-creds'
                    ]]) {
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Get Public IP') {
            steps {
                script {
                    def ip = sh(
                        script: "cd terraform && terraform output -raw public_ip",
                        returnStdout: true
                    ).trim()

                    env.EC2_IP = ip
                    echo "EC2 IP is ${env.EC2_IP}"
                }
            }
        }

        stage('Create Inventory') {
            steps {
                sh """
                echo "[web]" > inventory
                echo "${EC2_IP} ansible_user=ubuntu ansible_ssh_private_key_file=/var/jenkins_home/sec.pem" >> inventory
                """
            }
        }

        stage('Wait for SSH') {
            steps {
                sh """
                echo "Waiting for EC2 to be ready..."
                sleep 40
                """
            }
        }

        stage('Run Ansible') {
            steps {
                sh 'ansible-playbook -i inventory ansible/install_nginx.yml'
            }
        }
    }
}
