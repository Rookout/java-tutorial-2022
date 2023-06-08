FROM gradle:7.4.2-jdk17 AS build

COPY --chown=gradle:gradle . /app
WORKDIR /app
RUN gradle build --no-daemon 

FROM openjdk:17.0.2-jdk

RUN mkdir /app
COPY --from=build /app/build/libs/*.jar /app/todobackend-0.0.1-SNAPSHOT.jar

EXPOSE 8080
ENV SERVER_PORT 8080

RUN curl -L "https://search.maven.org/remote_content?g=com.rookout&a=rook&v=LATEST" -o /app/rook.jar
ENV JAVA_TOOL_OPTIONS "-javaagent:/app/rook.jar"

ENV ROOKOUT_TOKEN XXXXXXXXXXXXXXXX
ENV ROOKOUT_LABELS "env:dev"

ENTRYPOINT ["java", "-jar","app/todobackend-0.0.1-SNAPSHOT.jar"]
