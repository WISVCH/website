# Pin WordPress so Dependabot can propose and classify security patch updates.
FROM wordpress:7.1.5-php8.5-apache@sha256:05feeed1131c96103154f7a7a405a983a5b65a197b812f68cade590d3189d1de

# Install required packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl cron nano sendmail-bin sendmail rsyslog

# Download and install WP-CLI
RUN curl  -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv    wp-cli.phar /usr/local/bin/wp

RUN mkdir /var/log/php && touch /var/log/php/error.log && chown www-data:www-data /var/log/php/error.log

COPY php/php.ini             /usr/local/etc/php/conf.d/php.ini

COPY wordpress/wp-config.php /var/www/wp-config-custom.php

# Overwrite .htaccess
COPY wordpress/.htaccess     /var/www/.htaccess

COPY cron/cron.conf          /etc/cron.d/wordpress
RUN  chmod 600               /etc/cron.d/wordpress

COPY sendmail/sendmail.mc    /etc/mail/sendmail.mc
RUN m4 /etc/mail/sendmail.mc > /etc/mail/sendmail.cf

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
