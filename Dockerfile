FROM dunglas/frankenphp

# Enable settings PHP production
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

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
RUN composer install --no-dev --optimize-autoloader

# Ensure file worker frankenphp
RUN if [ ! -f public/frankenphp-worker.php ]; then echo '<?php' > public/frankenphp-worker.php; fi

# Install Laravel Octane with FrankenPHP Server
RUN echo "yes" | php artisan octane:install --server=frankenphp

# Set ENV
ENV APP_ENV=production
ENV APP_DEBUG=false

# Define Entrypoint / CMD
ENTRYPOINT ["php", "artisan", "octane:frankenphp", "--host=0.0.0.0", "--port=8000"]
