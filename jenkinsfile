pipeline {
    agent any
    tools {
        maven 'MAVEN_HOME' // Matches the name in Global Tool Configuration
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm // Automatically pulls code from your Git repo
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean compile' // Compiles the code
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test' // Runs your JUnit test cases
            }
            post {
                always {
                    // Integration: Publishes test reports to the Jenkins UI
                    junit '**/target/surefire-reports/*.xml' 
                }
            }
        }
        stage('Package') {
            steps {
                sh 'mvn package -DskipTests' // Creates the JAR file
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
                // Add deployment commands here (e.g., AWS CLI or SSH)
            }
        }
    }
}
  
