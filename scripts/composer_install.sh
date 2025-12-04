#!/bin/bash
cd /var/www/laravel
composer install --no-dev --prefer-dist --optimize-autoloader
php artisan config:clear
php artisan cache:clear
php artisan config:cache
