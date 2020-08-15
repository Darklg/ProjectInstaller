#!/bin/bash

# Wakatime
if [[ ! -f  "${BASEDIR}.wakatime" ]];then
    echo "${_PROJECT_NAME}" > "${BASEDIR}.wakatime";
fi;

# WordPress
if [[ "${_INSTALL_CMS}" == 'wordpress' ]];then
    # Sublime Project
    if [[ ! -f "${BASEDIR}${_PROJECT_NAME}.sublime-project" ]];then
        cp "${SCRIPTDIR}/tpl/sublime-project__wordpress.txt" "${BASEDIR}${_PROJECT_NAME}.sublime-project";
    fi;
fi;
