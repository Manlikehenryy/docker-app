# Used for prod build.
FROM php:8.1-fpm as php

# Set environment variables
ENV PHP_OPCACHE_ENABLE=1
ENV PHP_OPCACHE_ENABLE_CLI=0
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS=0
ENV PHP_OPCACHE_REVALIDATE_FREQ=0

# Install dependencies.
RUN apt-get update && apt-get install -y unzip libpq-dev libcurl4-gnutls-dev nginx libonig-dev

#  postgresql-dev 

# Install PHP extensions.
RUN docker-php-ext-install mysqli pdo pdo_mysql bcmath curl opcache mbstring pdo_pgsql


    	

# Copy composer executable.
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy configuration files.
COPY ./docker/php/php.ini /usr/local/etc/php/php.ini
COPY ./docker/php/php-fpm.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf

# Set working directory to ...
WORKDIR /app

# Copy files from current folder to container current folder (set in workdir).
COPY --chown=www-data:www-data . .

# Create laravel caching folders.
RUN mkdir -p ./storage/framework
RUN mkdir -p ./storage/framework/{cache, testing, sessions, views}
RUN mkdir -p ./storage/framework/bootstrap
RUN mkdir -p ./storage/framework/bootstrap/cache

# Adjust user permission & group.
RUN usermod --uid 1000 www-data
RUN groupmod --gid 1000  www-data

# Run the entrypoint file.
ENTRYPOINT [ "docker/entrypoint.sh" ]

# RUN composer install --no-ansi --no-dev --no-interaction --no-plugins --no-progress --no-scripts --optimize-autoloader
# RUN cp .env.example .env
# RUN php artisan clear
# RUN php artisan optimize:clear
# RUN php artisan migrate
# RUN chown -R www-data .
# RUN chown -R www-data /app/storage
# RUN chown -R www-data /app/storage/logs
# RUN chown -R www-data /app/storage/framework/sessions
# RUN chown -R www-data /app/bootstrap
# RUN chown -R www-data /app/bootstrap/cache
# RUN chmod -R 775 /app/storage
# RUN chmod -R 775 /app/storage/logs
# RUN chmod -R 775 /app/storage/framework
# RUN chmod -R 775 /app/storage/framework/sessions
# RUN chmod -R 775 /app/bootstrap
# RUN chmod -R 775 /app/bootstrap/cache
# RUN php-fpm -D
# RUN nginx -g "daemon off;"



