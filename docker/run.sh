#!/bin/sh

cd /var/www

composer install --optimize-autoloader --no-dev
# php artisan migrate:fresh --seed
php artisan cache:clear
php artisan route:cache

/usr/bin/supervisord -c /etc/supervisord.conf