FROM adminer

USER root
RUN apk add --no-cache --virtual .php-ext-deps \
       unixodbc freetds

RUN   apk add --no-cache --virtual .build-deps \
        unixodbc-dev freetds-dev

RUN docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr 


RUN docker-php-ext-install \
           pdo_odbc pdo_dblib

RUN  apk del .build-deps \
 && rm -rf /var/cache/apk/*

RUN chmod 4755 /bin/busybox
# RUN apk add iptables
# RUN iptables -F
# RUN iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
# RUN iptables -A INPUT -m state -state ESTABLISHED,RELATED -j ACCEPT
# RUN iptables -A OUTPUT -j ACCEPT
# RUN iptables -I OUTPUT -d 123.45.6.7 -j REJECT
# RUN docker exec -it proxy iptables -L -n

RUN sed -i 's/dblib:charset=utf8;/dblib:version=7.0;charset=utf8;/g' /var/www/html/adminer.php

USER adminer
CMD	[ "php", "-S", "[::]:8080", "-t", "/var/www/html" ]
EXPOSE 8080
