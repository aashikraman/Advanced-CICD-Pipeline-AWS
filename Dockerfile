FROM openjdk:8
ADD jarstaging/com/aashik/cicd-project/2.1.2/demo-workshop-2.1.2.jar sample_app.jar 
ENTRYPOINT [ "java", "-jar", "sample_app.jar" ]
