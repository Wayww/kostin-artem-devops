pipeline {
    agent any

    environment {
        STUDENT_NAME = 'Artem'
        STUDENT_SURNAME = 'Kostin'
        STUDENT_GROUP = 'IT23-14'
        STUDENT_ID = '37089'
        DOCKER_IMAGE = 'kostin-artem-devops'
        DOCKER_CONTAINER = 'kostin-artem-container'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh 'git rev-parse --short HEAD'
            }
        }

        stage('Build') {
            steps {
                sh 'python3 -m compileall -q app'
            }
        }

        stage('Test') {
            steps {
                sh 'python3 -m unittest discover -s tests -v'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t "$DOCKER_IMAGE:$BUILD_NUMBER" -t "$DOCKER_IMAGE:latest" .'
            }
        }

        stage('Docker Run') {
            steps {
                sh '''
                    docker rm -f "$DOCKER_CONTAINER" 2>/dev/null || true
                    docker run -d \
                      --name "$DOCKER_CONTAINER" \
                      -p 8080:8080 \
                      -e STUDENT_NAME="$STUDENT_NAME" \
                      -e STUDENT_SURNAME="$STUDENT_SURNAME" \
                      -e STUDENT_GROUP="$STUDENT_GROUP" \
                      -e STUDENT_ID="$STUDENT_ID" \
                      "$DOCKER_IMAGE:$BUILD_NUMBER"
                    for attempt in 1 2 3 4 5 6 7 8 9 10; do
                      if docker exec "$DOCKER_CONTAINER" \
                        python -c "import urllib.request; print(urllib.request.urlopen('http://localhost:8080/health').read().decode())"; then
                        break
                      fi
                      if [ "$attempt" -eq 10 ]; then
                        echo 'Health check failed'
                        exit 1
                      fi
                      sleep 1
                    done
                    docker logs "$DOCKER_CONTAINER"
                '''
                echo "Student: ${STUDENT_NAME} ${STUDENT_SURNAME}"
                echo "Group: ${STUDENT_GROUP}"
                echo "Student ID: ${STUDENT_ID}"
            }
        }
    }

    post {
        success {
            echo 'Finished: SUCCESS'
        }
        failure {
            sh 'docker logs "$DOCKER_CONTAINER" 2>/dev/null || true'
            echo 'Pipeline failed. Review the failed stage and Console Output.'
        }
    }
}
