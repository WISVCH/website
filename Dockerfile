FROM wordpress:php7.1-apache
LABEL maintainer="W3Cie \"w3cie@ch.tudelft.nl\""

# CH CA certificate for LDAP and MySQL TLS connections
RUN curl -so /usr/local/share/ca-certificates/wisvch.crt https://ch.tudelft.nl/certs/wisvch.crt && \
    chmod 644 /usr/local/share/ca-certificates/wisvch.crt && \
    update-ca-certificates

# Download and install WP-CLI
RUN curl  -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv    wp-cli.phar /usr/local/bin/wp

# Custom php.ini for sendmail path
COPY php.ini       /usr/local/etc/php/conf.d/php.ini
COPY wp-config.php /var/www/wp-config-custom.php

WORKDIR /var/www/html

# Custom entrypoint to install WP & replace wp-config
# As we replace the original entrypoint from wordpress Dockerfile
# we need to run that also in our replacement to actually install
# the wordpress and start the PHP.
COPY ./entrypoint.sh /custom-entrypoint.sh
RUN  chmod +x        /custom-entrypoint.sh

ENTRYPOINT ["/custom-entrypoint.sh"]

CMD ["apache2-foreground"]

EXPOSE 80
