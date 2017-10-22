FROM wordpress:php7.1-apache
LABEL maintainer="W3Cie \"w3cie@ch.tudelft.nl\""

# Install required packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
	curl cron nano

# Install CH CA certificate
RUN curl -so /etc/ssl/certs/wisvch.crt https://ch.tudelft.nl/certs/wisvch.crt && \
    chmod 644 /etc/ssl/certs/wisvch.crt && \
    update-ca-certificates

# Download and install WP-CLI
RUN curl  -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv    wp-cli.phar /usr/local/bin/wp


COPY php/php.ini             /usr/local/etc/php/conf.d/php.ini
COPY wordpress/wp-config.php /var/www/wp-config-custom.php
COPY cron/cron.conf          /etc/cron.d/wordpress
RUN  chmod 600               /etc/cron.d/wordpress


WORKDIR /var/www/html

# Custom entrypoint to install WP & replace wp-config
# As we replace the original entrypoint from wordpress Dockerfile
# we need to run that also in our replacement to actually install
# WordPress and start PHP.
COPY ./entrypoint.sh /custom-entrypoint.sh
RUN  chmod +x        /custom-entrypoint.sh

ENTRYPOINT ["/custom-entrypoint.sh"]

CMD ["apache2-foreground"]

EXPOSE 80
