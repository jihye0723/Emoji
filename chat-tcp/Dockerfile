FROM openjdk:8-jdk-alpine
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} chat.jar

ENTRYPOINT ["java","-jar","/chat.jar", "-Dspring-boot.run.arguments=--server.port=${SERVER_PORT}, --transfer.port=${TRANSFER_PORT}"]