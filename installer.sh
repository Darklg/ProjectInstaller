#!/bin/bash

_VERSION='0.2.3';
cat <<EOF

###################################
## Project Installer v ${_VERSION}
###################################

EOF

###################################
## Checks
###################################

if [[ -z "${_MYSQL_USER}" ]];then
    echo "Missing config file."
    return 0;
fi;

###################################
## Settings
###################################

SCRIPTDIR="$( dirname "${BASH_SOURCE[0]}" )/";
BASEDIR="$(pwd)/";

###################################
## Create local files
###################################

if [[ "${_INSTALL_TYPE}" == 'local' ]];then
    . "${SCRIPTDIR}inc/settings-local.sh";
else
    . "${SCRIPTDIR}inc/settings-notlocal.sh";
fi;

. "${SCRIPTDIR}inc/settings-all.sh";

###################################
## Clone Project
###################################

git clone "${_PROJECT_REPO}" "${_INSTALL_FOLDER}";
cd "${_INSTALL_FOLDER}";
git submodule update --init --recursive;

###################################
## Import database
###################################

cd "${BASEDIR}${_INSTALL_FOLDER}";

if [[ -f "${BASEDIR}dump.sql" ]];then
    echo "# Import database";
    mysql -h "${_MYSQL_HOST}" -u "${_MYSQL_USER}" -p "${_MYSQL_PASS}" "${_MYSQL_BASE}" < "${BASEDIR}dump.sql";
fi;

cd "${BASEDIR}";

###################################
## Install Project
###################################

# Deploy
. "${SCRIPTDIR}inc/deploy.sh";

# Composer
cd "${BASEDIR}${_INSTALL_FOLDER}";
if [[ -f "composer.json" ]];then
    composer install;
fi;
cd "${BASEDIR}";

# WP-Config
if [[ "${_INSTALL_CMS}" == 'wordpress' ]];then
    . "${SCRIPTDIR}inc/install-wp.sh";
fi;

