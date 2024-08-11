FROM nginx:latest
LABEL maintainer="cottagemad@gmail.com"
COPY server.c server.c
COPY nginx/nginx.conf /etc/nginx/nginx.conf
RUN apt update && \
 apt -y install gcc libfcgi-dev spawn-fcgi && \
 rm -rf /var/lib/apt/lists && \
 gcc server.c -lfcgi -o server && \
 chown nginx:nginx /var/cache/nginx /var/run && \
 chmod u-s usr/bin/newgrp && \
 chmod u-s bin/mount && \
 chmod u-s bin/umount && \
 chmod u-s usr/bin/gpasswd && \
 chmod g-s usr/bin/expiry && \
 chmod g-s usr/bin/wall && \
 chmod g-s usr/bin/chage && \
 chmod u-s bin/su && \
 chmod u-s usr/bin/chsh && \
 chmod u-s usr/bin/passwd && \
 chmod u-s usr/bin/chfn && \
 chmod g-s sbin/unix_chkpwd
USER nginx
HEALTHCHECK --interval=5s --timeout=10s --retries=3 CMD curl -sS 127.0.0.1 || exit 1
ENTRYPOINT spawn-fcgi -u nginx -g nginx -S -p 8080 server && \
 nginx -g 'daemon off;'
