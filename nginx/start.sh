#!/bin/sh

: ${FPM_PORT_9000_TCP_ADDR:?"Environment variable FPM_PORT_9000_TCP_ADDR missing."}
: ${FPM_PORT_9000_TCP_PORT:?"Environment variable FPM_PORT_9000_TCP_PORT missing."}

/bin/sed -i "s@<FPM_HOST>@${FPM_PORT_9000_TCP_ADDR}@" /etc/nginx/nginx.conf
/bin/sed -i "s@<FPM_PORT>@${FPM_PORT_9000_TCP_PORT}@" /etc/nginx/nginx.conf

/usr/sbin/nginx
