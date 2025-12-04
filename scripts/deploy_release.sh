#!/bin/bash
set -e

timestamp=$(date +%Y%m%d%H%M%S)
release_dir="/var/www/laravel/releases/$timestamp"

# Ensure permissions before moving
chown -R ubuntu:www-data /var/www/laravel/releases/tmp
chmod -R 775 /var/www/laravel/releases/tmp

# Move code from tmp → new release
mv /var/www/laravel/releases/tmp "$release_dir"

# Shared symlinks
ln -sfn /var/www/laravel/shared/.env "$release_dir/.env"
ln -sfn /var/www/laravel/shared/storage "$release_dir/storage"
ln -sfn /var/www/laravel/shared/bootstrap/cache "$release_dir/bootstrap/cache"

# Composer install
cd "$release_dir"
sudo -u ubuntu composer install --no-dev --optimize-autoloader

# Laravel optimize
php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true

# Point current → new release
ln -sfn "$release_dir" /var/www/laravel/current
