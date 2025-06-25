FROM php:8.2-fpm

# Prevent interaction and use non-interactive install mode
ENV DEBIAN_FRONTEND=noninteractive

# Update, install dependencies, clean cache properly
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        nginx \
        git \
        unzip \
        zip \
        curl \
        libpng-dev \
        libonig-dev \
        libxml2-dev \
        libzip-dev \
        npm \
        nodejs \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
