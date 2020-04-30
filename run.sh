#!/bin/bash

# Remove these files to get updated ones.
ssl_options="$PWD/conf.d/options-ssl-nginx.conf"
ssl_dhparams="$PWD/conf.d/ssl-dhparams.pem"

if [ ! -e "$ssl_options" ] || [ ! -e "$ssl_dhparams" ]; then
	base_url='https://raw.githubusercontent.com/certbot/certbot/master'
	curl -s "$base_url/certbot/certbot/ssl-dhparams.pem" > "$ssl_dhparams"
	curl -s "$base_url/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf" > "$ssl_options"
	echo "ssl_dhparam /etc/nginx/conf.d/ssl-dhparams.pem;" >> "$ssl_options"
fi

docker build -t nginx .
docker run --name nginx --rm -p "80:80" -p "443:443" \
           nginx
