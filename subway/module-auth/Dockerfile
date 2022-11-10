FROM openjdk:8-jdk-alpine
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} auth.jar

EXPOSE 8081/tcp
ENTRYPOINT ["java","-jar","/auth.jar"]