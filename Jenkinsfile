pipeline {
    agent any

    environment {
        DEPLOY_PLAYBOOK = 'ansible/deploy-laravel.yml'
        RECIPIENTS = 'srengty@gmail.com korbdaven@gmail.com'
    }

    triggers {
        pollSCM('H/5 * * * *')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/korb-daven/my-laravel-app.git'
            }
        }

        stage('Install Composer & NPM') {
            steps {
                sh 'composer install --no-interaction --prefer-dist || exit 1'
                sh 'npm install || exit 1'
                sh 'npm run build || exit 1'
            }
        }

        stage('Run') {
            steps {
                sh 'cp .env.example .env'
                sh 'php artisan config:clear'
                sh 'php artisan migrate:fresh ' //--env=testing || exit 1
                // sh 'php artisan test --env=testing || exit 1'
            }
        }

        stage('Deploy with Ansible') {
            steps {
                sh "ansible-playbook ${DEPLOY_PLAYBOOK}"
            }
        }
    }

    post {
        failure {
            emailext subject: "❌ Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                     body: """<p>Build failed on ${env.JOB_NAME} - #${env.BUILD_NUMBER}.</p>
                              <p>Console: ${env.BUILD_URL}console</p>""",
                     recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'CulpritsRecipientProvider']],
                     to: "${RECIPIENTS}"
        }
    }
}
