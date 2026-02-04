# Build Stage
FROM maven:3.8.4 

WORKDIR /app

COPY . .

RUN mvn clean package -DskipTests

# Run Stage

FROM openjdk:17-slim

WORKDIR /app

COPY --from=build /app/target/*.jar /app

EXPOSE 8081

ENTRYPOINT ["java", "-jar", "/app/tech365-0.0.1-SNAPSHOT.jar"]