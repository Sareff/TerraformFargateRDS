FROM alpine:3.12
RUN mkdir /server
COPY ./web-53 /server/
COPY ./config.yaml /server/
WORKDIR /server
EXPOSE 8080
CMD cd /server; chmod +x web-53; ./web-53