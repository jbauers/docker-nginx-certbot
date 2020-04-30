FROM nginx:stable-alpine

RUN apk add --no-cache bash certbot

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh

COPY scripts /scripts

# FIXME: Use a real email
ENV CERTBOT_EMAIL mail@example.com

# FIXME: Default to staging
ENV IS_STAGING 1

COPY conf.d /etc/nginx/conf.d
