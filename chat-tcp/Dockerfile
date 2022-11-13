FROM openjdk:8-jdk-alpine
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} chat.jar

EXPOSE 8101/tcp
ENTRYPOINT ["java","-jar","/chat.jar"]