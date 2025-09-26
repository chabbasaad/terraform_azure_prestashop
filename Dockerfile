# Custom PrestaShop Docker Image for Taylor Shift
# Based on official PrestaShop image with additional customizations

FROM prestashop/prestashop:latest

# Set maintainer information
LABEL maintainer="Taylor Shift Team"
LABEL description="Custom PrestaShop Docker image for Taylor Shift e-commerce platform"

# Install additional PHP extensions and tools
USER root

# Install additional system packages
RUN apt-get update && apt-get install -y \
    nano \
    vim \
    curl \
    wget \
    git \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install additional PHP extensions if needed
RUN docker-php-ext-install -j$(nproc) \
    bcmath \
    calendar \
    exif \
    gettext \
    sockets \
    dba \
    mysqli \
    pcntl \
    pdo_mysql \
    shmop \
    sysvmsg \
    sysvsem \
    sysvshm

# Set custom PHP configuration
COPY php.ini /usr/local/etc/php/conf.d/prestashop.ini

# Create directories for custom modules and themes
RUN mkdir -p /var/www/html/modules/custom \
    && mkdir -p /var/www/html/themes/custom \
    && chown -R www-data:www-data /var/www/html/modules/custom \
    && chown -R www-data:www-data /var/www/html/themes/custom

# Copy custom configuration files
COPY config/parameters.php.template /tmp/parameters.php.template

# Switch back to www-data user
USER www-data

# Set working directory
WORKDIR /var/www/html

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost/ || exit 1
