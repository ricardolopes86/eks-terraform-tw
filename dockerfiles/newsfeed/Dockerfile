FROM centos:centos7

RUN yum -y update; yum clean all
RUN yum install java-1.8.0-openjdk -y
RUN mkdir -p /app

COPY ./newsfeed.jar /app

ENV APP_PORT 8080

WORKDIR /app
CMD [ "java", "-jar", "newsfeed.jar" ] 