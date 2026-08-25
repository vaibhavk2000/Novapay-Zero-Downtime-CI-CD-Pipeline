FROM eclipse-temurin:21-jre

WORKDIR /app

COPY app/build/libs/app.jar app.jar

RUN useradd -u 10001 novapay

USER 10001

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]