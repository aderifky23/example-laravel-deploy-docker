FROM dunglas/frankenphp

# Install PHP Extensions
RUN install-php-extensions \
    pcntl \
    zip \
    bcmath \
    pdo_mysql \
    mysqli

# Set working directory
WORKDIR /app

# Copy all files to working directory
COPY . /app

# Install Composer 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dependencies
RUN composer install --ignore-platform-reqs --no-dev -a

# Chek config franken
RUN if [ ! -f public/frankenphp-worker.php ]; then echo '<?php' > public/frankenphp-worker.php; fi

# Install frankenphp
RUN echo "yes" | php artisan octane:install --server=frankenphp 

# Set Permission to storage and cache
RUN chmod -R 777 storage bootstrap/cache 

# Set ENV
ENV APP_ENV=production
ENV APP_DEBUG=false

# expose port
EXPOSE 8000

# Define Entrypoint / CMD
ENTRYPOINT ["php", "artisan", "octane:frankenphp"]
