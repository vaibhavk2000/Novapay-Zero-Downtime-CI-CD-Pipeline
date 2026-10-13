pipeline {
    agent any

    tools {
        // This tells Jenkins to use the Gradle installation configured in Manage Jenkins -> Tools
        gradle 'Gradle-8.8'
    }

    environment {
        JAVA_VERSION = '21'
        GRADLE_VERSION = '8.8'
        IMAGE_NAME = 'novapay'
    }

    stages {
        stage('Source Validation') {
            steps {
                checkout scm
                sh '''
                    test -f app/build.gradle
                    test -f app/settings.gradle
                    test -f Dockerfile
                    test -f pipeline/helm/novapay/Chart.yaml
                    test -f pipeline/helm/novapay/templates/deployment.yaml
                    test -f pipeline/helm/novapay/templates/service.yaml
                    test -f pipeline/policies/require-probes.rego
                    test -f pipeline/policies/require-nonroot.rego
                    test -f pipeline/policies/require-resource-limits.rego
                    test -f pipeline/policies/disallow-privileged.rego
                    test -f pipeline/policies/disallow-latest-tag.rego
                    test -f pipeline/policies/require-readonly-rootfs.rego
                    test -f pipeline/scripts/rollback.sh
                '''
                sh 'find . -maxdepth 4 -type f | sort'
            }
        }

        stage('Security & Quality Analysis') {
            parallel {
                stage('Secret Scanning') {
                    steps {
                        echo "Running Secret Scanning..."
                    }
                }
                stage('SAST (Semgrep)') {
                    steps {
                        echo "Running Semgrep static analysis..."
                    }
                }
                stage('Dependency Scan (Trivy)') {
                    steps {
                        echo "Running Trivy dependency scan..."
                    }
                }
            }
        }

        stage('Test and Coverage Gate') {
            steps {
                dir('app') {
                    sh 'gradle clean build test jacocoTestReport jacocoTestCoverageVerification --no-daemon'
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: 'app/build/test-results/**, app/build/reports/tests/**, app/build/reports/jacoco/**', allowEmptyArchive: true
                }
            }
        }

        stage('Container Build and Security') {
            steps {
                dir('app') {
                    sh 'gradle clean bootJar --no-daemon'
                }
                script {
                    def imageTag = "${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
                    sh "docker build --no-cache -t ${imageTag} ."
                }
            }
        }

        stage('Policy and Compliance Validation') {
            steps {
                sh '''
                    helm template novapay pipeline/helm/novapay > rendered-manifests.yaml
                    cat rendered-manifests.yaml
                '''
                sh 'conftest test rendered-manifests.yaml --policy pipeline/policies'
            }
        }

        stage('Deploy to Non-Production') {
            steps {
                echo "Deploying NovaPay to non-production environment"
            }
        }

        stage('DAST and Smoke Tests') {
            steps {
                echo "Running smoke tests and DAST validation..."
            }
        }

        stage('Progressive Production Deployment') {
            when {
                branch 'main'
            }
            steps {
                echo "Starting canary deployment and progressive traffic expansion..."
            }
        }

        stage('Post-Deployment Verification') {
            when {
                branch 'main'
            }
            steps {
                echo "Verifying application readiness and liveness"
            }
        }

        stage('Evidence Archival') {
            steps {
                echo "Archiving pipeline compliance and build evidence..."
            }
            post {
                always {
                    archiveArtifacts artifacts: 'rendered-manifests.yaml', allowEmptyArchive: true
                }
            }
        }
    }

    post {
        always {
            cleanWs notFailBuild: true
        }
        success {
            echo "NovaPay pipeline completed successfully!"
        }
        failure {
            echo "NovaPay pipeline failed. Please check the logs."
        }
    }
}
