FROM openjdk:11-jre-slim

LABEL com.joom.retention.maxCount=5
LABEL com.joom.retention.maxDays=90
LABEL com.joom.retention.pullProtectDays=30

RUN apt-get update && \
    apt-get install -y uuid-runtime

WORKDIR /app

# Here, we copy the common artifacts required for any of our Spark Connect
# clients (primarily spark-connect-client-jvm, as well as spark-hive,
# hadoop-aws, scala-library, etc.).
COPY build/libs/* /app/

COPY src/main/docker/entrypoint.sh /app/
RUN chmod +x ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
