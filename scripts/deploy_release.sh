#!/bin/bash
set -e

timestamp=$(date +%Y%m%d%H%M%S)
release_dir="/var/www/laravel/releases/$timestamp"
shared_dir="/var/www/laravel/shared"

# Ensure release directory exists
mkdir -p "$release_dir"

# Fix permissions before moving
chown -R ubuntu:www-data /var/www/laravel/releases/tmp
chmod -R 775 /var/www/laravel/releases/tmp

# Move code from tmp → new release
mv /var/www/laravel/releases/tmp/* "$release_dir"
rm -rf /var/www/laravel/releases/tmp

# -------------------------------------------------------------------
# SHARED FILES & DIRECTORIES
# -------------------------------------------------------------------

# .env
ln -sfn "$shared_dir/.env" "$release_dir/.env"

# storage
ln -sfn "$shared_dir/storage" "$release_dir/storage"

# bootstrap/cache
mkdir -p "$release_dir/bootstrap"
ln -sfn "$shared_dir/bootstrap/cache" "$release_dir/bootstrap/cache"

# database directory for sqlite
mkdir -p "$release_dir/database"
ln -sfn "$shared_dir/database/database.sqlite" "$release_dir/database/database.sqlite"

# -------------------------------------------------------------------
# COMPOSER INSTALL
# -------------------------------------------------------------------
cd "$release_dir"
sudo -u ubuntu composer install --no-dev --optimize-autoloader

# Laravel optimize
php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true

# -------------------------------------------------------------------
# Switch current -> new release
# -------------------------------------------------------------------
ln -sfn "$release_dir" /var/www/laravel/current

echo "Deployment complete: $release_dir"
