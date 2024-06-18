#!/bin/bash

_PROJECT_INSTALLER_VERSION='0.12.1';
cat <<EOF

###################################
## Project Installer v ${_PROJECT_INSTALLER_VERSION}
###################################

EOF

###################################
## Settings
###################################

SCRIPTDIR="$( dirname "${BASH_SOURCE[0]}" )/";
BASEDIR="$(pwd)/";
if [[ -z "${_PROJECT_GITBRANCH}" ]];then
    _PROJECT_GITBRANCH='';
fi;

###################################
## Includes
###################################

_BASHUT_FILE="${SCRIPTDIR}tools/BashUtilities/bashutilities.sh";
if [[ ! -f "${_BASHUT_FILE}" ]];then
    $(cd "${SCRIPTDIR}" && git submodule update --init --recursive);
fi;
. "${_BASHUT_FILE}";

###################################
## Create config
###################################

if [[ "${1}" == 'create' ]];then
    . "${SCRIPTDIR}inc/create-config.sh";
    return 0;
fi;

###################################
## Checks
###################################

if [[ -z "${_MYSQL_USER}" ]];then
    echo "Missing config file. You can create one if needed :"
    echo ". ${SCRIPTDIR}installer.sh create;"
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
