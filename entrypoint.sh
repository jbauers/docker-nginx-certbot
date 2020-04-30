#!/bin/bash

trap "exit" INT TERM
trap "kill 0" EXIT

source /scripts/util.sh

auto_enable_configs

nginx -g "daemon off;" &
NGINX_PID=$!

while [ true ]; do
    if ! ps aux | grep [n]ginx ; then
        exit 1
    fi

    /scripts/certbot.sh
    kill -HUP $NGINX_PID

    sleep 604810 &
    SLEEP_PID=$!

    wait -n "$SLEEP_PID" "$NGINX_PID"
done
