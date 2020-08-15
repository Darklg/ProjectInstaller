#!/bin/bash

# Folders
if [[ ! -d "${BASEDIR}logs" ]];then
    mkdir "${BASEDIR}logs";
fi;
if [[ ! -d "${BASEDIR}backups" ]];then
    mkdir "${BASEDIR}backups";
fi;

# WordPress
if [[ "${_INSTALL_CMS}" == 'wordpress' ]];then
    # WP-CLI
    if [[ ! -f "${BASEDIR}wp-cli.phar" ]];then
        curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    fi;
fi;

