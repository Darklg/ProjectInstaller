#!/bin/bash

if [[ -f "install.sh" ]];then
    echo '- Config file already exists';
    return 0;
fi;

cp "${SCRIPTDIR}tpl/base-config-file.sh" "install.sh";
echo ". ${SCRIPTDIR}installer.sh;" >> "install.sh";
echo '- Config file installed. Please edit it and launch it.';

