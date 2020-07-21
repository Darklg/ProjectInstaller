#!/bin/bash

# Wakatime
echo "${_PROJECT_NAME}" > "${BASEDIR}.wakatime";

# WordPress
if [[ "${_INSTALL_CMS}" == 'wordpress' ]];then
    # Sublime Project
    cp "${SCRIPTDIR}/tpl/sublime-project__wordpress.txt" "${BASEDIR}${_PROJECT_NAME}.sublime-project";

    # WP-CLI
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
fi;
