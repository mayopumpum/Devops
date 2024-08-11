OUT =server
NGINX_CONF =`pwd`/nginx.conf

.PHONY: server

install:
	sudo apt install libfcgi-dev
	sudo apt install spawn-fcgi
	sudo apt-get install nginx

all: server nginx spawn

server:
	gcc server.c -lfcgi -o $(OUT)

nginx:
	sudo nginx -c $(NGINX_CONF)

spawn:
	spawn-fcgi -p 8080 $(OUT)

clean:
	rm $(OUT)
