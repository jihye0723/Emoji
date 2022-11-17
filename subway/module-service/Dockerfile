FROM openjdk:8-jdk-alpine
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} service.jar

EXPOSE 8082/tcp
ENTRYPOINT ["java","-jar","/service.jar"]