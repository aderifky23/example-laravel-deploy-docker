FROM dunglas/frankenphp:latest

# Install PHP Extensions
RUN install-php-extensions \
    pcntl \
    zip \
    bcmath \
    pdo_mysql \
    mysqli

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /app

# Copy all files to working directory
COPY . /app

# Install dependencies
RUN composer install

# Ensure file worker frankenphp
RUN if [ ! -f public/frankenphp-worker.php ]; then echo '<?php' > public/frankenphp-worker.php; fi

# Install Laravel Octane with FrankenPHP Server
RUN echo "yes" | php artisan octane:install --server=frankenphp

# Set Permission
RUN chmod -R 777 storage bootstrap/cache

# Set ENV
ENV APP_ENV=production
ENV APP_DEBUG=false

# Tentukan port
EXPOSE 8000

# Define Entrypoint / CMD
ENTRYPOINT ["php", "artisan", "octane:frankenphp"]
