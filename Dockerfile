FROM eclipse-temurin:21-jre

RUN useradd -r -u 10001 appuser

WORKDIR /app

COPY app/build/libs/*.jar app.jar

USER 10001

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]