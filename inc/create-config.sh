#!/bin/bash

###################################
## Create file
###################################

_INSTALL_FILE="${BASEDIR}install.sh";

if [[ -f "${_INSTALL_FILE}" ]];then
    echo '- Config file already exists';
    return 0;
fi;

cp "${SCRIPTDIR}tpl/base-config-file.sh" "${_INSTALL_FILE}";
echo ". ${SCRIPTDIR}installer.sh;" >> "${_INSTALL_FILE}";
echo '- Config file installed. Please edit it and launch it.';

###################################
## Replace items
###################################

# Project
_PROJECT_DIRNAME="${PWD##*/}";
_use_project_dirname=$(bashutilities_get_yn "- Is this project named '${_PROJECT_DIRNAME}' ?" 'y');
if [[ "${_use_project_dirname}" == 'y' ]];then
    bashutilities_sed "s/myproject/${_PROJECT_DIRNAME}/g" "${_INSTALL_FILE}";
fi;
