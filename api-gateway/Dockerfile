FROM openjdk:8-jdk-alpine
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} apiGateway.jar

EXPOSE 8080/tcp
ENTRYPOINT ["java","-jar","/apiGateway.jar"]