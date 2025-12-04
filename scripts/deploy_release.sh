#!/bin/bash
set -e

timestamp=$(date +%Y%m%d%H%M%S)
release_dir="/var/www/laravel/releases/$timestamp"
shared_dir="/var/www/laravel/shared"

# Tạo thư mục release
mkdir -p "$release_dir"

# Di chuyển code từ tmp → release folder
mv /var/www/laravel/releases/tmp/* "$release_dir"
rm -rf /var/www/laravel/releases/tmp

# Tạo symlink các file shared
ln -sfn "$shared_dir/.env" "$release_dir/.env"
ln -sfn "$shared_dir/storage" "$release_dir/storage"
mkdir -p "$release_dir/bootstrap"
ln -sfn "$shared_dir/bootstrap/cache" "$release_dir/bootstrap/cache"

# Install vendor (nếu cần)
cd "$release_dir"
composer install --no-dev --optimize-autoloader

# Laravel optimize (không bắt buộc strict → dùng || true)
php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true

# Cập nhật symlink current
ln -sfn "$release_dir" /var/www/laravel/current

echo "Deployment complete: $release_dir"
