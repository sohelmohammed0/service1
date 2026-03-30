FROM public.ecr.aws/amazoncorretto/amazoncorretto:17-al2023-headless AS build
RUN yum install -y maven
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM public.ecr.aws/amazoncorretto/amazoncorretto:17-al2023-headless
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]