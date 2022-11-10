FROM openjdk:8-jdk-alpine
ARG JAR_FILE=build/libs/module-auth.jar
COPY ${JAR_FILE} auth.jar

EXPOSE 8081/tcp
ENTRYPOINT ["java","-jar","/auth.jar"]