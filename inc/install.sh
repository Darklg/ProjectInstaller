#!/bin/bash

###################################
## Create local files
###################################

if [[ "${_INSTALL_TYPE}" == 'local' ]];then
    . "${SCRIPTDIR}inc/settings-local.sh";
else
    . "${SCRIPTDIR}inc/settings-notlocal.sh";
fi;

. "${SCRIPTDIR}inc/settings-all.sh";

###################################
## Clone Project
###################################

git clone "${_PROJECT_REPO}" "${_INSTALL_FOLDER}";
cd "${_INSTALL_FOLDER}";
git submodule update --init --recursive;

###################################
## Import first SQL Available
###################################

cd "${BASEDIR}${_INSTALL_FOLDER}";

_SQL_FILES="${BASEDIR}*.sql";

for _sql_file in $_SQL_FILES; do
    echo "# Import database : ${_sql_file}";
    mysql -h "${_MYSQL_HOST}" -u "${_MYSQL_USER}" -p"${_MYSQL_PASS}" "${_MYSQL_BASE}" < "${_sql_file}";
    break 1;
done

cd "${BASEDIR}";

###################################
## Install Project
###################################

# Deploy
. "${SCRIPTDIR}inc/deploy.sh";

# Composer
cd "${BASEDIR}${_INSTALL_FOLDER}";
if [[ -f "composer.json" ]];then
    composer install;
fi;
cd "${BASEDIR}";

# WP-Config
if [[ "${_INSTALL_CMS}" == 'wordpress' ]];then
    . "${SCRIPTDIR}inc/install-wp.sh";
fi;

cd "${BASEDIR}";
if [[ -f "${BASEDIR}post-install.sh" ]];then
    . "${BASEDIR}post-install.sh";
fi;
