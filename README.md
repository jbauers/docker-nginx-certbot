# Nginx with automated HTTPS and renewal

More or less the same as https://github.com/staticfloat/docker-nginx-certbot,
but a bit less: Uses Alpine, which has certbot packaged, and we also don't want
compose or fancy red error codes.

FIXME: `stat -c` is used to check whether a cert should be renewed, which is
"simple". OpenSSL should be used to check the validity instead. Arguably those
files should never be touched, but copying the certs will break renewal. This
may or may not be an issue depending on the setup.

## Usage

To test everything:

1. Add `example.com` to your `/etc/hosts` (localhost HTTPS redirect may be special)
2. `./run.sh`

If renewal fails because of an email, add a real one to the `Dockerfile`. If you're
not on a public box and certbot tries to renew, you can `touch certs/*.pem` and Nginx
can start up (and won't renew). This is because of the FIXME above - if you've just
cloned this repo, it won't be an issue, but after a week you'll run into it.

On a public box, things should _just work_.

## Let's Encrypt

Check the `scripts` folder to see how it works. It uses certbot and renews
weekly. A default `conf/common.conf` points HTTP 80 to localhost on port
1337. This is where certbot will be listening, see `scripts/run_certbot.sh`.

Note that servers only speak HTTPS, so don't even listen on port 80 for those.
`conf/common.conf` will redirect everything to HTTPS (except localhost). Only
certbot's ACME challenge speaks plain HTTP in order to get SSL certificates.

The following directives are required in each Nginx `server` block:

```
ssl_certificate /etc/letsencrypt/live/MY_DOMAIN/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/MY_DOMAIN/privkey.pem;
```

Apart from that, any server block like `conf/example.conf` can be added, and will
automatically get updated certs each week.

# Notes

This is a template. Fork it and add your own Nginx configs. There's really not that
much here.

## Why?

One day, when I'm less lazy, I'd like to fix the FIXME and maybe have a look at the
regex stuff. For now I just wanted something more standard than the provided one and
use an Alpine base. I also prefer a `./run.sh` over `docker-compose up` and there's
some HSTS and cache stuff in here.
