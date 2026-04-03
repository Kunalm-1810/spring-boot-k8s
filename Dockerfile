# Use the official replacement image for Java 8
FROM eclipse-temurin:8-jdk

EXPOSE 8080
ADD target/springboot-crud-k8s.jar springboot-crud-k8s.jar
ENTRYPOINT ["java","-jar","/springboot-crud-k8s.jar"]



 
