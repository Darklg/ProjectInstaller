#!/bin/bash

# WordPress
if [[ "${_INSTALL_CMS}" == 'wordpress' ]];then
    if [[ ! -d "${BASEDIR}wputools" ]];then
        git clone https://github.com/WordPressUtilities/wputools "${BASEDIR}wputools";
    fi;
    . "${BASEDIR}wputools/inc/installer.sh";
fi;


