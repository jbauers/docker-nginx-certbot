# Nginx with automated HTTPS and renewal

More or less the same as https://github.com/staticfloat/docker-nginx-certbot,
but a bit less. Uses Alpine, which has certbot packaged, and we also don't want
compose or fancy red error codes.

## Quickstart

- Look at the scripts in `scripts`
- Adjust configuration files in `conf.d`
- Add production settings in `Dockerfile`
- Run `./run.sh`

### Quicker start

- `./run.sh`

## Let's Encrypt

Check the `scripts` folder to see how it works. It uses certbot and renews
weekly. A default `conf.d/default.conf` points HTTP 80 to localhost on port
1337. This is where certbot will be listening, see `scripts/certbot.sh`.

The following directives are required in each Nginx `server` block:

```
ssl_certificate /etc/letsencrypt/live/<MY_DOMAIN>/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/<MY_DOMAIN>/privkey.pem;
```

Apart from that, any server block like `conf.d/example.com.conf` can be added, and will
automatically get updated certs.

# Notes

This is a template. Fork it and add your own Nginx configs. There's really not that
much here.

## Why?

For now I just wanted something more standard than the provided one and use an Alpine base.
I also prefer a `./run.sh` over `docker-compose up`.
