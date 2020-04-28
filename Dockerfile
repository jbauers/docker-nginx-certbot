FROM nginx:stable-alpine

RUN apk add --no-cache bash certbot

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh

COPY scripts /scripts

ENV CERTBOT_EMAIL mail@example.com

# COPY example.com /usr/share/nginx/html/example.com
COPY conf.d /etc/nginx/conf.d
