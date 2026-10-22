
FROM php:8.4.27-apache

LABEL org.opencontainers.image.title="Minimalist Web Notepad"
LABEL org.opencontainers.image.source="https://github.com/pereorga/minimalist-web-notepad"

# Conservar el directorio de la imagen anterior
ENV APACHE_DOCUMENT_ROOT=/app

WORKDIR /app

# Configurar Apache para servir /app
RUN a2enmod rewrite \
    && sed -ri 's!/var/www/html!/app!g' \
        /etc/apache2/sites-available/000-default.conf \
        /etc/apache2/apache2.conf \
        /etc/apache2/conf-available/docker-php.conf \
    && printf '%s\n' \
        '<Directory /app>' \
        '    Options FollowSymLinks' \
        '    AllowOverride All' \
        '    Require all granted' \
        '</Directory>' \
        > /etc/apache2/conf-available/notepad.conf \
    && a2enconf notepad

# Copiar la aplicación
COPY --chown=www-data:www-data . /app/

# Crear directorio de notas
RUN mkdir -p /app/_tmp \
    && chown -R www-data:www-data /app/_tmp \
    && chmod 750 /app/_tmp

EXPOSE 80

CMD ["apache2-foreground"]
