#!/bin/bash

###################################
## Create file
###################################

_INSTALL_FILE="${BASEDIR}install.sh";

if [[ -f "${_INSTALL_FILE}" ]];then
    echo '- Config file already exists';
    return 0;
fi;

if [[ -f "wp-config.php" ]];then
    echo '- This is the project directory. Going to the parent folder.';
    cd ..;
    BASEDIR="$(pwd)/";
    _INSTALL_FILE="${BASEDIR}install.sh";
fi;

cp "${SCRIPTDIR}tpl/base-config-file.sh" "${_INSTALL_FILE}";
echo ". ${SCRIPTDIR}installer.sh;" >> "${_INSTALL_FILE}";
echo '- Config file installed. Please edit it and launch it.';

###################################
## Replace items
###################################

# Project
_PROJECT_DIRNAME="${PWD}";
_PROJECT_DIRNAME=${_PROJECT_DIRNAME//\/htdocs/};
_PROJECT_DIRNAME="${_PROJECT_DIRNAME##*/}";
_use_project_dirname=$(bashutilities_get_yn "- Is this project named '${_PROJECT_DIRNAME}' ?" 'y');
if [[ "${_use_project_dirname}" == 'y' ]];then
    bashutilities_sed "s/myproject/${_PROJECT_DIRNAME}/g" "${_INSTALL_FILE}";
fi;

# Repository
if [[ -f "${BASEDIR}htdocs/.git/config" ]];then
    _PROJECT_REPO=$(cd "${BASEDIR}htdocs/" && git config --get remote.origin.url);
    bashutilities_sed "s#mygitrepository#${_PROJECT_REPO}#g" "${_INSTALL_FILE}";
fi;

# MySQL
_config_file="${BASEDIR}htdocs/wp-config.php";
if [[ -f "${_config_file}" ]];then
    _TMP_DB_NAME=$(bashutilities_search_extract_file__php_constant "DB_NAME" "${_config_file}");
    _TMP_DB_USER=$(bashutilities_search_extract_file__php_constant "DB_USER" "${_config_file}");
    _TMP_DB_PASSWORD=$(bashutilities_search_extract_file__php_constant "DB_PASSWORD" "${_config_file}");
    _TMP_DB_HOST=$(bashutilities_search_extract_file__php_constant "DB_HOST" "${_config_file}");
    _TMP_DB_PREFIX=$(bashutilities_search_extract_file "\$table_prefix =" "';" "${_config_file}");
    _TMP_DB_PREFIX=${_TMP_DB_PREFIX/\'/};
    if [[ -n "${_TMP_DB_NAME}" && -n "${_TMP_DB_USER}" && -n "${_TMP_DB_PASSWORD}" && -n "${_TMP_DB_HOST}" && -n "${_TMP_DB_PREFIX}" ]];then
        echo "NAME : ${_TMP_DB_NAME}";
        echo "USER : ${_TMP_DB_USER}";
        echo "PASSWORD : ${_TMP_DB_PASSWORD}";
        echo "HOST : ${_TMP_DB_HOST}";
        echo "PREFIX : ${_TMP_DB_PREFIX}";
        _use_tmp_values=$(bashutilities_get_yn "- Use MySQL values?" 'y');
        if [[ "${_use_tmp_values}" == 'y' ]];then
            bashutilities_sed "s#mysqlbase#${_TMP_DB_NAME}#g" "${_INSTALL_FILE}";
            bashutilities_sed "s#mysqluser#${_TMP_DB_USER}#g" "${_INSTALL_FILE}";
            bashutilities_sed "s#mysqlpass#${_TMP_DB_PASSWORD}#g" "${_INSTALL_FILE}";
            bashutilities_sed "s#mysqlhost#${_TMP_DB_HOST}#g" "${_INSTALL_FILE}";
            bashutilities_sed "s#mysqlpref_#${_TMP_DB_PREFIX}#g" "${_INSTALL_FILE}";
        fi;
    fi;
fi;
