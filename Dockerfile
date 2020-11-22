# 1st stage, build the app
FROM maven:3.6.3-openjdk-8 as build
MAINTAINER Kurenai kurenai233@yahoo.com

WORKDIR /bilibili-helper

# Create a first layer to cache the "Maven World" in the local repository.
# Incremental docker builds will always resume after that, unless you update
# the pom
ADD pom.xml .
RUN mvn package -DskipTests

# Do the Maven build!
# Incremental docker builds will resume here when you change sources
ADD src src
RUN mvn package -DskipTests

RUN echo "done!"

# 2nd stage, build the runtime image
FROM openjdk:8-jre-slim

WORKDIR /bilibili-helper

# Copy the binary built in the 1st stage
COPY --from=build /bilibili-helper/target/BILIBILI-HELPER-jar-with-dependencies.jar ./

ENTRYPOINT ["java", "-jar", "BILIBILI-HELPER-jar-with-dependencies.jar"]