pipeline {
    agent any

    stages {
        stage('Start Services') {
            steps {
                echo "Starting InfluxDB, Grafana, and JMeter environment..."
                sh 'docker compose up -d --build'
            }
        }

        stage('Run JMeter Test') {
            steps {
                echo "Running JMeter test..."
                // Run your existing batch file
                bat 'jmeterRun.bat dockerJMeterTest.jmx'
            }
        }

        stage('Archive Results') {
            steps {
                echo "Archiving JMeter results..."
                archiveArtifacts artifacts: 'results/**/*', fingerprint: true
            }
        }
    }

    post {
        always {
            echo "Cleaning up containers..."
            sh 'docker compose down'
        }
    }
}
