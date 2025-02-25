FROM dunglas/frankenphp

RUN apt-get update && apt-get install -y ca-certificates curl

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

# Install frankenphp
RUN echo "yes" | php artisan octane:install --server=frankenphp 

# Set Permission to storage and cache
RUN chmod -R 777 storage bootstrap/cache 

# Set ENV
ENV APP_ENV=production
ENV APP_DEBUG=true

# Define Entrypoint / CMD
ENTRYPOINT ["php", "artisan", "octane:frankenphp", "--host=0.0.0.0", "--port=8083"]
