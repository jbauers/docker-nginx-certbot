#!/bin/bash

. $(cd $(dirname $0); pwd)/util.sh

if [ -z "$CERTBOT_EMAIL" ]; then
    echo "CERTBOT_EMAIL environment variable undefined; certbot will do nothing"
    exit 1
fi

for domain in $(parse_domains); do
    if is_renewal_required $domain; then
        if ! get_certificate $domain $CERTBOT_EMAIL; then
            echo "Cerbot failed for $domain. Check the logs for details."
            echo 1
        fi
    else
        echo "Not run certbot for $domain; last renewal happened just recently."
    fi
done

auto_enable_configs
