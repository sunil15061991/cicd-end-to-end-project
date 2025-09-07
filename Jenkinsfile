pipeline {
    agent {
        node {
            label 'jenkins-slave-node'
        }
    }
    environment {
        PATH = "/opt/apache-maven-3.9.11/bin:$PATH"
    }
    stages {
        stage("build code"){
            steps {
                echo "----------- build started ----------"
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo "---------- build completed ------------"
            }
        }
        stage("test stage"){
            steps{
                echo "----------- unit test started ----------"
                sh 'mvn surefire-report:report'
                echo "---------- unit test Completed ----------"
            }
        }
        /*stage('SonarQube analysis') {
            environment {
                scannerHome = tool 'sonar-scanner-1'
            }
            steps{
                withSonarQubeEnv('sonarqube-server') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }

        stage("Quality Gate") {
            steps {
                script {
                    timeout(time: 1, unit: 'HOURS') { 
                        def qg = waitForQualityGate() 
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }*/

        stage("Artifact Publish") {
            steps {
                script {
                    echo '------------- Artifact Publish Started ------------'
                    def server = Artifactory.newServer url:"https://trialbabqpy.jfrog.io//artifactory" ,  credentialsId:"jfrog-cred"
                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "staging/(*)",
                                "target": "sunil-local-repo/{1}",
                                "flat": "false",
                                "props" : "${properties}",
                                "exclusions": [ "*.sha1", "*.md5"]
                            }
                        ]
                    }"""
                    def buildInfo = server.upload(uploadSpec)
                    buildInfo.env.collect()
                    server.publishBuildInfo(buildInfo)
                    echo '------------ Artifact Publish Ended -----------'  
                }
            }   
        }

        stage(" Create Docker Image ") {
            steps {
                script {
                    echo '-------------- Docker Build Started -------------'
                    app = docker.build("trialbabqpy.jfrog.io/sunil-docker-local/myapp:1.0.1")
                    echo '-------------- Docker Build Ended ---------------'
                }
            }
        }

        stage (" Docker Publish "){
            steps {
                script {
                        echo '---------- Docker Publish Started --------'  
                        docker.withRegistry("https://trialbabqpy.jfrog.io", 'jfrog-cred'){
                        app.push()
                        echo '------------ Docker Publish Ended ---------'  
                    }    
                }
            }
        }

    }
}
 