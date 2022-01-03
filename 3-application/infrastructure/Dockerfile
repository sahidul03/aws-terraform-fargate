FROM openjdk:alpine

EXPOSE 80
ADD springbootapp.jar springbootapp.jar
ENTRYPOINT ["java","-jar","-Xms1024m","-Xmx1800m","springbootapp.jar"]
