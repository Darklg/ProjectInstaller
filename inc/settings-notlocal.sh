#!/bin/bash

# WordPress
if [[ "${_INSTALL_CMS}" == 'wordpress' ]];then
    git clone https://github.com/WordPressUtilities/wputools;
    . wputools/inc/installer.sh;
fi;


