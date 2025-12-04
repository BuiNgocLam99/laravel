#!/bin/bash
set -e

# Xóa thư mục tmp release trước đó (nếu có)
rm -rf /var/www/laravel/releases/tmp
mkdir -p /var/www/laravel/releases/tmp
