#!/bin/sh
set -e

echo "🚀 Starting Pterodactyl Panel..."

# Change to app directory
cd /var/www/pterodactyl

# Wait for database to be ready
echo "⏳ Waiting for database connection..."
until php artisan db:show 2>&1 | grep -q "Connection"; do
    echo "Database not ready yet, waiting..."
    sleep 5
done
echo "✅ Database connection established!"

# Generate app key if not exists
if [ -z "$APP_KEY" ]; then
    echo "🔑 Generating application key..."
    php artisan key:generate --force
else
    echo "✅ Application key already set"
fi

# Clear config cache
echo "🧹 Clearing configuration cache..."
php artisan config:clear || true
php artisan cache:clear || true
php artisan view:clear || true

# Run migrations
echo "📦 Running database migrations..."
php artisan migrate --force --seed

# Optimize application
echo "⚡ Optimizing application..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Set proper permissions
echo "🔐 Setting proper permissions..."
chown -R www-data:www-data /var/www/pterodactyl/storage /var/www/pterodactyl/bootstrap/cache
chmod -R 755 /var/www/pterodactyl/storage /var/www/pterodactyl/bootstrap/cache

echo "✅ Pterodactyl Panel is ready!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📌 To create an admin user, run:"
echo "   php artisan p:user:make"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Start supervisord
exec /usr/bin/supervisord -c /etc/supervisord.conf
