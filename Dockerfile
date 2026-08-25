FROM eclipse-temurin:21-jre

WORKDIR /app

COPY app/build/libs/*.jar app.jar

RUN useradd -r -u 10001 novapay

USER 10001

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
