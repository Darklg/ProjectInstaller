#!/bin/bash

###################################
## Remove tmp WPUTools
###################################

if [[ "${_INSTALL_TYPE}" == 'local' ]];then
    rm -rf "${BASEDIR}wputools";
    rm -rf "${BASEDIR}wp-cli.phar";
fi;
