#!/bin/bash
set -e

timestamp=$(date +%Y%m%d%H%M%S)
release_dir="/var/www/laravel/releases/$timestamp"

# Di chuyển code từ tmp → release folder
mv /var/www/laravel/releases/tmp "$release_dir"

# Copy shared resources
ln -sfn /var/www/laravel/shared/.env "$release_dir/.env"
ln -sfn /var/www/laravel/shared/storage "$release_dir/storage"
ln -sfn /var/www/laravel/shared/bootstrap/cache "$release_dir/bootstrap/cache"

# Install vendor (nếu cần)
cd "$release_dir"
composer install --no-dev --optimize-autoloader

# Laravel optimize
php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true

# Cập nhật symlink current
ln -sfn "$release_dir" /var/www/laravel/current
