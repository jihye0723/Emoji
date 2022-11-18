FROM openjdk:8-jdk-alpine
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} chat.jar

ENTRYPOINT ["java","-jar","/chat.jar", "--args=--server.port=${SERVER_PORT}, --transfer.port=${TRANSFER_PORT}"]