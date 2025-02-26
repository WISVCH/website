<?php
define('DISALLOW_FILE_EDIT', true);
define('WP_MEMORY_LIMIT', '160M');
define('WP_MAX_MEMORY_LIMIT', '256M');
define('WP_POST_REVISIONS', 10);
define('DISABLE_WP_CRON', true);

define('WP_DEBUG', false);
define('WP_DEBUG_DISPLAY', false);

// Strip port from HTTP_HOST
if (isset($_SERVER['HTTP_HOST'])) {
    $_SERVER['HTTP_HOST'] = substr($_SERVER['HTTP_HOST'], 0, strrpos($_SERVER['HTTP_HOST'], ':'));
}

if (!isset($_SERVER['HTTP_HOST']) || $_SERVER['HTTP_HOST'] == "") {
    $_SERVER['HTTP_HOST'] = getenv('HTTP_HOST');
}

// Enable HTTPS
define('FORCE_SSL_ADMIN', true);
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && strpos($_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false) {
    $_SERVER['HTTPS'] = 'on';
    $_SERVER['SERVER_PORT'] = 443;
}

// Set varnish cache ip for purge plugin
if (getenv('VARNISH_SVC_SERVICE_HOST')) {
    define('VHP_VARNISH_IP', getenv('VARNISH_SVC_SERVICE_HOST'));
}
