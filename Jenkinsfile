pipeline {
    agent any
    tools {
        // Ensure 'MAVEN_HOME' is the EXACT name you gave 
        // in Manage Jenkins > Tools > Maven installations
        maven 'MAVEN_HOME' 
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm 
            }
        }
        stage('Build') {
            steps {
                // Use 'bat' instead of 'sh' for Windows
                bat 'mvn clean compile' 
            }
        }
        stage('Test') {
            steps {
                bat 'mvn test' 
            }
            post {
                always {
                    // This path is usually fine, but being specific prevents 
                    // the SAXParseException you saw earlier
                    junit 'target/surefire-reports/*.xml' 
                }
            }
        }
        stage('Package') {
            steps {
                bat 'mvn package -DskipTests' 
            }
            post {
                success {
                    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
                }
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying to AWS/Server...'
                // For Windows deployment to AWS, you would use:
                // bat 'aws s3 cp target/*.jar s3://your-bucket-name/'
            }
        }
    }
}
