pipeline {
    agent any

    environment {
        DEPLOY_PLAYBOOK = 'ansible/deploy-laravel.yml'
        RECIPIENTS = 'srengty@gmail.com'
    }

    triggers {
        pollSCM('H/5 * * * *') // Poll every 5 minutes
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/yourname/your-laravel-repo.git'
            }
        }

        stage('Install Composer & NPM') {
            steps {
                sh 'composer install --no-interaction --prefer-dist'
                sh 'npm install'
                sh 'npm run build'
            }
        }

        stage('Run Tests (SQLite)') {
            steps {
                sh 'cp .env.testing .env'
                sh 'php artisan config:clear'
                sh 'php artisan migrate:fresh --env=testing'
                sh 'php artisan test --env=testing'
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
                              <p>Check console: ${env.BUILD_URL}console</p>""",
                     recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'CulpritsRecipientProvider']],
                     to: "${RECIPIENTS}"
        }
    }
}
