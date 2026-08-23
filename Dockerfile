FROM eclipse-temurin:21-jdk AS build
WORKDIR /workspace
COPY app/ .
RUN chmod +x gradlew 2>/dev/null || true
RUN ./gradlew bootJar --no-daemon
FROM eclipse-temurin:21-jre
RUN useradd -r -u 10001 appuser
WORKDIR /app
COPY --from=build /workspace/build/libs/*.jar app.jar
USER 10001
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
