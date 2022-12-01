#!/bin/bash

# Wakatime
if [[ ! -f  "${BASEDIR}.wakatime" ]];then
    echo "${_PROJECT_NAME}" > "${BASEDIR}.wakatime";
fi;

# Editor Config
_EDITOR_CONFIG_FILE="${BASEDIR}/.editorconfig";
if [[ ! -f "${_EDITOR_CONFIG_FILE}" ]];then
    cp "${SCRIPTDIR}/tpl/editorconfig.txt" "${_EDITOR_CONFIG_FILE}";
fi;

# WordPress
if [[ "${_INSTALL_CMS}" == 'wordpress' ]];then
    # Sublime Project
    _SUBLIME_PROJECT_FILE="${BASEDIR}${_PROJECT_NAME}.sublime-project";
    if [[ ! -f "${_SUBLIME_PROJECT_FILE}" ]];then
        cp "${SCRIPTDIR}/tpl/sublime-project__wordpress.txt" "${_SUBLIME_PROJECT_FILE}";
        bashutilities_sed "s/projectid/${_PROJECT_ID}/g" "${_SUBLIME_PROJECT_FILE}";
    fi;
    # Install tmp WPUTools
    if [[ ! -d "${BASEDIR}wputools" ]];then
        git clone https://github.com/WordPressUtilities/wputools "${BASEDIR}wputools";
    fi;
fi;

