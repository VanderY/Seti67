# our base build image
FROM maven:3.6.0-jdk-11 as maven

# copy the project files
COPY ./pom.xml ./pom.xml

# build all dependencies
RUN mvn dependency:go-offline -B

# copy your other files
COPY ./src ./src

# build for release
RUN mvn package -DskipTests

# our final base image
FROM openjdk:11-jre

# set deployment directory
WORKDIR /my-project
COPY ./src ./src

# copy over the built artifact from the maven image
COPY --from=maven target/sirius-0.0.1-SNAPSHOT.jar ./

# set the startup command to run your binary
CMD ["java", "-jar", "./sirius-0.0.1-SNAPSHOT.jar"]