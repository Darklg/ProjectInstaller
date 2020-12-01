#!/bin/bash

_VERSION='0.5.1';
cat <<EOF

###################################
## Project Installer v ${_VERSION}
###################################

EOF

###################################
## Settings
###################################

SCRIPTDIR="$( dirname "${BASH_SOURCE[0]}" )/";
BASEDIR="$(pwd)/";

###################################
## Checks
###################################

if [[ -z "${_MYSQL_USER}" ]];then
    echo "Missing config file."
    return 0;
fi;

###################################
## Start
###################################

if [[ -d "${_INSTALL_FOLDER}" ]];then
    echo "Project is already installed."
    read -p "Do you want to package it ? [0/1] : " _package_project;
    if [[ "${_package_project}" == '1' ]];then
        . "${SCRIPTDIR}inc/package.sh";
    fi;
else
    . "${SCRIPTDIR}inc/install.sh";
fi;
