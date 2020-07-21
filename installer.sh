#!/bin/bash

_VERSION='0.1.3';
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
fi;

. "${SCRIPTDIR}inc/settings-all.sh";

###################################
## Import database
###################################

if [[ -f "dump.sql" ]];then
    echo "# Import database";
fi;

###################################
## Clone Project
###################################

git clone "${_PROJECT_REPO}" "${_INSTALL_FOLDER}";
cd "${_INSTALL_FOLDER}";
git submodule update --init --recursive;

###################################
## Install Project
###################################

# Deploy
. "${SCRIPTDIR}inc/deploy.sh";

# Composer
if [[ -f "composer.json" ]];then
    composer install;
fi;

# WP-Config
if [[ "${_INSTALL_CMS}" == 'wordpress' ]];then
    . "${SCRIPTDIR}inc/install-wp.sh";
fi;
