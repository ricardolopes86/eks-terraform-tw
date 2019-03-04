FROM centos:centos7

RUN yum -y update; yum clean all
RUN yum install java-1.8.0-openjdk -y
RUN mkdir -p /app

COPY ./front-end.jar /app

ENV APP_PORT 9000

WORKDIR /app
CMD [ "java", "-jar", "front-end.jar" ] 