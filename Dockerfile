FROM nginx:stable-alpine

RUN apk add --no-cache bash certbot

COPY entrypoint.sh /entrypoint.sh
COPY scripts /scripts

ENTRYPOINT /entrypoint.sh

ENV CERTBOT_EMAIL mail@example.com

# COPY example.com /usr/share/nginx/html/example.com
COPY conf /etc/nginx/conf.d
