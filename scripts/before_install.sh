#!/bin/bash
set -e

mkdir -p /var/www/laravel/releases/tmp
chown -R ubuntu:www-data /var/www/laravel/releases
chmod -R 775 /var/www/laravel/releases
