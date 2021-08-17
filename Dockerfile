# FROM bitpod/nginx-nodejs:latest
FROM certbot/dns-google:v1.18.0

ENV app="/opt/certbot"

RUN apk add  --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.7/main/ nodejs=8.9.3-r1 && \
    npm install yarn -g && \
    apk update && \
    apk add git --no-cache

COPY ["./main.js", "$app/"]

CMD ["node $app/main.js"]