# syntax=docker/dockerfile:1
FROM php:8.3-fpm-alpine AS base

# Install system dependencies
RUN apk add --no-cache \
    nginx \
    supervisor \
    curl \
    git \
    unzip \
    libpng \
    libpng-dev \
    libjpeg-turbo \
    libjpeg-turbo-dev \
    freetype \
    freetype-dev \
    libzip \
    libzip-dev \
    libxml2 \
    libxml2-dev \
    oniguruma \
    oniguruma-dev \
    mysql-client \
    autoconf \
    g++ \
    make \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        gd \
        pdo \
        pdo_mysql \
        mysqli \
        mbstring \
        bcmath \
        dom \
        zip \
        opcache \
    && apk del --no-cache \
        libpng-dev \
        libjpeg-turbo-dev \
        freetype-dev \
        libzip-dev \
        libxml2-dev \
        oniguruma-dev \
        autoconf \
        g++ \
        make

# Install Node.js 18 LTS (compatible with older webpack)
RUN apk add --no-cache nodejs~=18 npm

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/pterodactyl

# Install Pterodactyl Panel
FROM base AS installer

# Download and extract Pterodactyl Panel
ARG PANEL_VERSION=v1.11.7
RUN curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/download/${PANEL_VERSION}/panel.tar.gz \
    && tar -xzf panel.tar.gz \
    && rm panel.tar.gz

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-progress

# Build frontend assets with legacy OpenSSL provider
ENV NODE_OPTIONS=--openssl-legacy-provider
RUN npm install --legacy-peer-deps \
    && npm run build \
    && rm -rf node_modules

# Production image
FROM base AS production

# Copy application files
COPY --from=installer /var/www/pterodactyl /var/www/pterodactyl

# Copy configuration files
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisord.conf
COPY entrypoint.sh /entrypoint.sh

# Set permissions
RUN chown -R www-data:www-data /var/www/pterodactyl/storage /var/www/pterodactyl/bootstrap/cache \
    && chmod -R 755 /var/www/pterodactyl/storage /var/www/pterodactyl/bootstrap/cache \
    && chmod +x /entrypoint.sh

# Create necessary directories
RUN mkdir -p /var/log/supervisor /run/nginx /var/log/nginx

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/up || exit 1

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
