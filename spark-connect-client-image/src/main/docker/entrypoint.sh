#!/bin/bash

set -eo pipefail

if [[ ${SPARK_CONNECT_URI} != sc://* ]] ; then
  echo "SPARK_CONNECT_URI environment variable is required and should start with sc://"
  exit 1
fi

if [[ -z ${MAIN_CLASS} ]] ; then
  echo "MAIN_CLASS environment variable is required"
  exit 1
fi

if [[ ${MAIN_APPLICATION_FILE_S3_PATH} != s3://* ]] ; then
  echo "MAIN_APPLICATION_FILE_S3_PATH environment variable is required and should start with s3://"
  exit 1
fi

echo Starting Spark Connect application with SPARK_CONNECT_URI=${SPARK_CONNECT_URI}, MAIN_CLASS=${MAIN_CLASS}, MAIN_APPLICATION_FILE_S3_PATH=${MAIN_APPLICATION_FILE_S3_PATH}

# This variable will also be used in the SparkSession builder within
# the application code.
export SPARK_CONNECT_MAIN_APPLICATION_FILE_PATH="/tmp/$(uuidgen).jar"

# Download the JAR with the code and specific dependencies of the client
# application to be run. All such JAR files are stored in S3, and when
# creating a client Pod, the path to the required JAR is passed to it
# via environment variables.
java -cp "/app/*" com.joom.analytics.sc.client.S3Downloader ${MAIN_APPLICATION_FILE_S3_PATH} ${SPARK_CONNECT_MAIN_APPLICATION_FILE_PATH}

# Launch the client application. Any MAIN_CLASS initializes a SparkSession
# at the beginning of its execution using the code provided above.
java -cp ${SPARK_CONNECT_MAIN_APPLICATION_FILE_PATH}:"/app/*" ${MAIN_CLASS} "$@"
