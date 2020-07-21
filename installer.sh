#!/bin/bash

local _VERSION='0.1.0';
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
    mkdir "${BASEDIR}logs";
fi;
mkdir "${BASEDIR}backups";

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

# Composer
if [[ -f "composer.json" ]];then
    composer install;
fi;

# WP-Config
if [[ "${_INSTALL_CMS}" == 'wordpress' ]];then
    cp "${SCRIPTDIR}/tpl/sublime-project__wordpress.txt" "${_PROJECT_NAME}.sublime-project";
fi;