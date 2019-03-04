FROM python:3.6-alpine

RUN ["mkdir", "-p", "/app"]

COPY . /app

WORKDIR /app

EXPOSE 8000

CMD [ "python3.6", "server.py" ] 