#!/bin/bash

/bin/sed -i "s@listen = /var/run/php5-fpm.sock@listen = 9000@" /etc/php5/fpm/pool.d/www.conf

chown -R www-data:www-data /opt/symfony/app/cache
chown -R www-data:www-data /opt/symfony/app/logs

exec /usr/sbin/php5-fpm --nodaemonize
