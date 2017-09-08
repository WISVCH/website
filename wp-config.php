<?php
define( 'DISALLOW_FILE_EDIT', true );
define( 'WP_MEMORY_LIMIT', '160M' );
define( 'WP_MAX_MEMORY_LIMIT', '256M' );
define( 'WP_POST_REVISIONS', 5 );

define( 'WP_DEBUG', false );
define( 'WP_DEBUG_LOG', false );
define( 'WP_DEBUG_DISPLAY', false );

if(isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https'){
  $_SERVER['HTTPS'] = 'on';
  $_SERVER['SERVER_PORT'] = 443;
}
