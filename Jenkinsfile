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

        stage('Terraform Init & Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Get EC2 Public IP') {
            steps {
                script {
                    env.EC2_IP = sh(
                        script: "cd terraform && terraform output -raw public_ip",
                        returnStdout: true
                    ).trim()
                }
            }
        }

        stage('Deploy Nginx with Ansible') {
            steps {
                script {
                    // Export ansible.cfg if needed
                    sh 'export ANSIBLE_CONFIG=$WORKSPACE/ansible.cfg'

                    // Create dynamic inventory
                    sh """
                    echo "[web]" > inventory
                    echo "${EC2_IP} ansible_user=ec2-user ansible_ssh_private_key_file=/var/jenkins_home/sec.pem" >> inventory
                    """

                    // Run the playbook
                    sh 'ansible-playbook -i inventory ansible/install_nginx.yml'
                }
            }
        }
    }
}
