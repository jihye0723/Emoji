FROM openjdk:8-jdk-alpine
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} eureka.jar

EXPOSE 8761
ENTRYPOINT ["java","-jar","/eureka.jar"]