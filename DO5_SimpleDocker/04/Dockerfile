FROM nginx

WORKDIR /server
COPY server.c server.c
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY start.sh start.sh
RUN apt update && \
 apt -y install gcc libfcgi-dev spawn-fcgi && \
 gcc server.c -lfcgi -o server && chmod +x start.sh

CMD ["./start.sh"]
