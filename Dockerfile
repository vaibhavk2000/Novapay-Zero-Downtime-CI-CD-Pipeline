FROM eclipse-temurin:21-jre-jammy

RUN useradd --system --uid 10001 --no-create-home appuser

WORKDIR /app

COPY app/build/libs/*.jar app.jar

RUN chown appuser:appuser app.jar

USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
