#!/bin/bash

# Plough through all config files looking for domains for Let's Encrypt.
parse_domains() {
    for conf_file in /etc/nginx/conf.d/*.conf*; do
        sed -n -r -e 's&^\s*ssl_certificate_key\s*\/etc/letsencrypt/live/(.*)/privkey.pem;\s*(#.*)?$&\1&p' $conf_file | xargs echo
    done
}

# Given a config file path, spit out all the ssl_certificate_key file paths.
parse_keyfiles() {
    sed -n -e 's&^\s*ssl_certificate_key\s*\(.*\);&\1&p' "$1"
}

# Given a config file path, return 0 if all keyfiles exist (or there are no
# keyfiles), return 1 otherwise
keyfiles_exist() {
    for keyfile in $(parse_keyfiles $1); do
	    currentfile=${keyfile//$'\r'/}
        if [ ! -f $currentfile ]; then
            echo "Couldn't find keyfile $currentfile for $1"
            return 1
        fi
    done
    return 0
}

# Helper function that sifts through /etc/nginx/conf.d/, looking for configs
# that don't have their keyfiles yet, and disabling them through renaming.
auto_enable_configs() {
    for conf_file in /etc/nginx/conf.d/*.conf*; do
        if keyfiles_exist $conf_file; then
            if [ ${conf_file##*.} = nokey ]; then
                echo "Found all the keyfiles for $conf_file, enabling..."
                mv $conf_file ${conf_file%.*}
            fi
        else
            if [ ${conf_file##*.} = conf ]; then
                echo "Keyfile(s) missing for $conf_file, disabling..."
                mv $conf_file $conf_file.nokey
            fi
        fi
    done
}

# Helper function to ask certbot for staging or production certificates. The
# EMAIL environment variable is required.
get_certificate() {
    echo "Getting certificate for domain $1 on behalf of user $2"
    PRODUCTION_URL='https://acme-v02.api.letsencrypt.org/directory'
    STAGING_URL='https://acme-staging-v02.api.letsencrypt.org/directory'

    if [ "${IS_STAGING}" = "1" ]; then
        letsencrypt_url=$STAGING_URL
        echo "Staging ..."
    else
        letsencrypt_url=$PRODUCTION_URL
        echo "Production ..."
    fi

    echo "running certbot ... $letsencrypt_url $1 $2"
    certbot certonly --agree-tos --keep -n --text --email $2 --server \
        $letsencrypt_url -d $1 --http-01-port 1337 \
        --standalone --preferred-challenges http-01 --debug
}
