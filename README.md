#Apache Kafka examples
This repository includes examples demonstrating how to use the New Java Kafka Producer and Consumer.
All examples are based on Kafka 0.11.0.0 and Java 1.7+. 

Some of the example ideas are borrowed from [@confluentinc](https://github.com/confluentinc/examples/), [@gwenshap](https://github.com/gwenshap/kafka-examples) and Apache Kafka Opensource community.





pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                // Checkout the source code from your version control system
                // For example, using Git:
                git 'https://github.com/example/repo.git'
            }
        }
        stage('Build') {
            steps {
                // Perform your build steps here
            }
        }
        stage('Deploy') {
            steps {
                // Access the changeset information
                script {
                    // Get the affected files in the changeset
                    def affectedFiles = CHANGESET['items']
                    
                    // Print the affected files
                    for (def file : affectedFiles) {
                        println "Modified File: ${file.path}"
                    }
                    
                    // Get the commit message
                    def commitMessage = CHANGESET['msg']
                    println "Commit Message: ${commitMessage}"
                }
                
                // Deploy your application or perform other actions based on the changeset
            }
        }
    }
}

