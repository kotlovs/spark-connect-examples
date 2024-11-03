# Spark Connect Client Image Example

An example of a Docker image used to run client applications on Spark Connect.

To build this image, set the appropriate `dockerImageName` in [build.gradle](build.gradle) and run:

```bash
cd spark-connect-client-image
../gradlew buildDockerImage
```
