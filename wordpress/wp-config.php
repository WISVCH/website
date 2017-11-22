<?php
define('DISALLOW_FILE_EDIT', true);
define('WP_MEMORY_LIMIT', '160M');
define('WP_MAX_MEMORY_LIMIT', '256M');
define('WP_POST_REVISIONS', 10);
define('DISABLE_WP_CRON', true);

define('WP_DEBUG', false);
define('WP_DEBUG_DISPLAY', false);

define('FORCE_SSL_ADMIN', true);

if(isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && strpos($_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false) {
	$_SERVER['HTTPS'] = 'on';
	$_SERVER['SERVER_PORT'] = 443;
}
