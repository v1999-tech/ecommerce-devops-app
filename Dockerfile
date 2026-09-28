# =========================================================
# STAGE 1: BUILD THE APPLICATION
# =========================================================

# Use a Maven image that already contains Java 17.
# Maven is required to compile and package our Spring Boot application.
# "builder" is the name given to this build stage.
# FROM maven:3.9.6-eclipse-temurin-17 AS builder

# Set /app as the working directory inside the container.
# All following commands will work from this directory.
# WORKDIR /app

# Copy pom.xml from our local project into /app in the container.
# pom.xml contains Maven dependencies and build configuration.
# COPY pom.xml .

# Copy the application's source code into /app/src.
# COPY src ./src

# Build/package the Spring Boot application using Maven.
# -B = batch mode, useful for automated/CI builds.
# package = compile, test phase, and create the JAR.
# -DskipTests = skip executing tests during this Docker build.
# The generated JAR will be created inside /app/target/.
# RUN mvn -B package -DskipTests


# ==================================================================
# STAGE 2: RUN THE APPLICATION
# ==================================================================

# Start a new, lightweight runtime image 
# JREis enough to run Java Application; Maven is not required
# Alpine is a lightweight linux distribution.
FROM eclipse-temurin:17-jre-alpine

# Set /app as the working directory in the runtime container
WORKDIR /app

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy only the JARfile from the "builder" stage
# We do not copy maven, source code, or build files
# This keeps the final runtime image smaller and clearner
# COPY --from=builder /app/target/*.jar /app.jar

COPY target/*.jar /app/app.jar

RUN chown -R appuser:appgroup /app

USER appuser

# Document that the application uses the port provided by PORT
EXPOSE 8080

# Command executed when the container starts 
# It starts our spring boot application using java
ENTRYPOINT ["java", "-jar", "/app.jar"]
 
