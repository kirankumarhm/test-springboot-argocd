# Use a lightweight Eclipse Temurin JDK runtime
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy the fat JAR file into the image container
COPY target/*.jar app.jar

# Expose the internal Tomcat web server port
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]