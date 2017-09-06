#!/bin/bash

# mute CMD from official wordpress image entrypoint.
sed -i -e 's/^exec "$@"/#exec "$@"/g' /usr/local/bin/docker-entrypoint.sh

# Run the docker-entrypoint of official wordpress image to do the installation.
bash /usr/local/bin/docker-entrypoint.sh $1

# Update hostname and restart mail tools.
# echo "127.0.0.1 $(hostname) localhost localhost.localdomain" >> /etc/hosts
# postconf "smtputf8_enable = no"
# postfix start

# Wait until WordPress has been installed
until wp core version --allow-root; do
  sleep 1;
done;

# Append extra code to wp-config.php
wp core config \
  --force \
  --allow-root \
  --skip-check \
  --dbname=${WORDPRESS_DB_NAME} \
  --dbuser=${WORDPRESS_DB_USER} \
  --dbpass=${WORDPRESS_DB_PASSWORD} \
  --dbhost=${WORDPRESS_DB_HOST} \
  --dbprefix=${WORDPRESS_DB_PREFIX} \
  --extra-php <<PHP
    require_once('/var/www/wp-config-custom.php');
PHP

# Remove default / inactive plugins
echo
echo "Removing default plugins..."

wp plugin delete $(wp plugin list --field=name --status=inactive --allow-root) --allow-root

# Install theme
echo
echo "Installing theme..."

# TODO check if theme already installed
if [[ "${W3CIE_THEME}" ]]; then
  wp theme install ${W3CIE_THEME} --allow-root;
fi

# Install plugins
echo
echo "Installing plugins..."

if [[ "${W3CIE_PLUGINS}" ]]; then
  for i in $(echo ${W3CIE_PLUGINS} | sed "s/,/ /g")
  do
    # TODO check if plugin already installed
    wp plugin install $i --allow-root;
  done
fi

# Remove default / inactive themes
echo
echo "Removing default themes..."

wp theme delete $(wp theme list --field=name --status=inactive --allow-root) --allow-root

# Fix permissions
echo
echo "Setting permissions..."

chown -R www-data /var/www/html/*
chown    www-data /var/www/wp-config-custom.php

echo
echo "...done!"

# execute CMD
exec "$@"
