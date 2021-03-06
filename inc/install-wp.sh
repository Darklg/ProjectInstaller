#!/bin/bash

cd "${BASEDIR}${_INSTALL_FOLDER}";

###################################
## Test WordPress
###################################

if [[ ! -d "wp-includes" ]];then
    echo "# No WordPress install was found.";
    . "${SCRIPTDIR}inc/clean.sh";
    return 0;
fi;

###################################
## Generate WP-Config
###################################

_PHP_EXTRA="";
if [[ "${_PROJECT_HTTP}" == 'https' ]];then
    _PHP_EXTRA=$(cat <<PHP
\$_SERVER['REQUEST_SCHEME'] = 'https';
\$_SERVER['HTTPS'] = 'on';
PHP
);
else
    _PROJECT_HTTP='http';
fi;

php "${BASEDIR}wp-cli.phar" core config --dbhost=${_MYSQL_HOST} --dbname=${_MYSQL_BASE} --dbuser=${_MYSQL_USER} --dbpass=${_MYSQL_PASS} --dbprefix=${_MYSQL_PREFIX} --extra-php <<PHP

# URLs
if(!isset(\$_SERVER['HTTP_HOST']) || !\$_SERVER['HTTP_HOST']){
    \$_SERVER['HTTP_HOST'] = '${_PROJECT_DOMAIN}';
}
if(!isset(\$_SERVER['SERVER_PROTOCOL']) || !\$_SERVER['SERVER_PROTOCOL']){
    \$_SERVER['SERVER_PROTOCOL'] = 'HTTP/1.0';
}

${_PHP_EXTRA}

define('WP_SITEURL', '${_PROJECT_HTTP}://' . \$_SERVER['HTTP_HOST'] . '/');
define('WP_HOME', '${_PROJECT_HTTP}://' . \$_SERVER['HTTP_HOST'] . '/');

# CRONs
define('DISABLE_WP_CRON', true);

# Environment
define('WPU_ENVIRONMENT', '${_INSTALL_TYPE}');
define('WP_ENVIRONMENT_TYPE', '${_INSTALL_TYPE}');

# Config
define('EMPTY_TRASH_DAYS', 7);
define('WP_POST_REVISIONS', 6);

# Memory
define('WP_MEMORY_LIMIT', '128M');
define('WP_MAX_MEMORY_LIMIT', '256M');

# Updates
define('AUTOMATIC_UPDATER_DISABLED', true);
define('WP_AUTO_UPDATE_CORE', true);

# Debug
define('WP_DEBUG', true);
if (WP_DEBUG) {
    @ini_set('display_errors', 0);
    if (!defined('WP_DEBUG_DISPLAY')) {
        define('WP_DEBUG_DISPLAY', false);
    }
    if (!defined('WP_DEBUG_LOG')) {
        define('WP_DEBUG_LOG', dirname(__FILE__) . '/../logs/debug-' . date('dmY') . '.log');
    }
    if (!defined('SCRIPT_DEBUG')) {
        define('SCRIPT_DEBUG', 1);
    }
    if (!defined('SAVEQUERIES')) {
        define('SAVEQUERIES', 1);
    }
}

PHP

###################################
## Database
###################################

if [[ -f "${BASEDIR}dump.tar.gz" ]];then
    echo "# Import database";
    . "${BASEDIR}wputools/wputools.sh" dbimport "${BASEDIR}dump.tar.gz";
fi;

###################################
## Flush
###################################

php "${BASEDIR}wp-cli.phar" rewrite flush --hard;

###################################
## Create settings file
###################################

. "${BASEDIR}wputools/wputools.sh" settings

###################################
## Init theme scripts
###################################

if [[ "${_INSTALL_TYPE}" == 'local' ]];then
    THEME_FOLDERS="${BASEDIR}htdocs/wp-content/themes/*"
    for theme_folder in $THEME_FOLDERS
    do
        if [[ ! -f "${theme_folder}/package.json" ]];then
            continue;
        fi;

        # Do not install parent theme scripts
        if [[ `basename ${theme_folder}` == "WPUTheme" ]];then
            continue;
        fi;

        echo "Installing '${theme_folder}' theme scripts..."
        $(cd "${theme_folder}" && yarn);
    done
fi;
