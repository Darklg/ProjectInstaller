#!/bin/bash

cd "${_INSTALL_FOLDER}";

###################################
## Generate WP-Config
###################################

php "${BASEDIR}wp-cli.phar" core config --dbhost=${_MYSQL_HOST} --dbname=${_MYSQL_BASE} --dbuser=${_MYSQL_USER} --dbpass=${_MYSQL_PASS} --dbprefix=${_MYSQL_PREFIX} --extra-php <<PHP

# URLs
if(!isset(\$_SERVER['HTTP_HOST']) || !\$_SERVER['HTTP_HOST']){
    \$_SERVER['HTTP_HOST'] = '${_PROJECT_DOMAIN}';
}
if(!isset(\$_SERVER['SERVER_PROTOCOL']) || !\$_SERVER['SERVER_PROTOCOL']){
    \$_SERVER['SERVER_PROTOCOL'] = 'HTTP/1.0';
}
define('WP_SITEURL', '${_PROJECT_HTTP}://' . \$_SERVER['HTTP_HOST'] . '/');
define('WP_HOME', '${_PROJECT_HTTP}://' . \$_SERVER['HTTP_HOST'] . '/');

# CRONs
define('DISABLE_WP_CRON', true);

# Environment
define('WPU_ENVIRONMENT', '${_INSTALL_TYPE}');

# Config
define('EMPTY_TRASH_DAYS', 7);
define('WP_POST_REVISIONS', 6);

# Memory
define('WP_MEMORY_LIMIT', '128M');
define('WP_MAX_MEMORY_LIMIT', '256M');

# Debug
define('WP_DEBUG', true);
if (WP_DEBUG) {
    @ini_set('display_errors', 0);
    if (!defined('WP_DEBUG_LOG')) { define('WP_DEBUG_LOG', '${BASEDIR}logs/debug.log'); }
    if (!defined('WP_DEBUG_DISPLAY')) { define('WP_DEBUG_DISPLAY', false); }
    if (!defined('SCRIPT_DEBUG')) { define('SCRIPT_DEBUG', 1); }
    if (!defined('SAVEQUERIES')) { define('SAVEQUERIES', 1); }
}

##WPUINSTALLER##
PHP

###################################
## Flush
###################################

php "${BASEDIR}wp-cli.phar" rewrite flush --hard;
