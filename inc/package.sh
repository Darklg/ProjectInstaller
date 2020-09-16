#!/bin/bash

###################################
## Backup
###################################

cd "${BASEDIR}/${_INSTALL_FOLDER}";

if [[ -f "wp-config.php" ]];then
    wputools backup;
fi;

###################################
## Keep a copy of the code dir
###################################

cd "${BASEDIR}/${_INSTALL_FOLDER}";

# Delete useless folders
rm -rf .git vendor var wp-content/cache wp-content/uploads;
find . -name 'node_modules' -type d -prune -print -exec rm -rf '{}' \;

cd "${BASEDIR}";

_DATE_STAMP=$(date "+%H%M%S%d%m%y");
zip -r "htdocs-${_DATE_STAMP}.zip" "${_INSTALL_FOLDER}"

###################################
## Delete files
###################################

cd "${BASEDIR}";
rm deploy.sh wputools-local.sh wp-cli.phar wputools-local.sh wputools-urls.txt *.sublime-project *.sublime-workspace;
rm -rf logs;
rm -rf "${BASEDIR}/${_INSTALL_FOLDER}";
