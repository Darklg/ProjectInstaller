#!/bin/bash

# Folders
mkdir "${BASEDIR}logs";
mkdir "${BASEDIR}backups";

# WordPress
if [[ "${_INSTALL_CMS}" == 'wordpress' ]];then
    # WP-CLI
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
fi;

