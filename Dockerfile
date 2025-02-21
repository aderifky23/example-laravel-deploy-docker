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
RUN composer install --no-dev --optimize-autoloader || (cat /app/composer.log && exit 1)

# Set ENV
ENV APP_ENV=production
ENV APP_DEBUG=false

# Define Entrypoint / CMD
ENTRYPOINT ["php", "artisan", "octane:frankenphp"]
