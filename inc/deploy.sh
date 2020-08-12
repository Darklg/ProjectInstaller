#!/bin/bash

# Load script
_deploy_file=$(cat <<EOF
#!/bin/bash

cd "${BASEDIR}${_INSTALL_FOLDER}";
git pull;
git submodule update --init --recursive;

EOF
);

if [[ "${_INSTALL_CMS}" == 'wordpress' ]];then
    _deploy_file=$(cat <<EOF
${_deploy_file}
echo \$(date +%s) > ${BASEDIR}${_INSTALL_FOLDER}/wp-content/uploads/version.txt;
/bin/bash ${BASEDIR}wputools/wputools.sh cache;
EOF
);
fi;

echo "${_deploy_file}" >> "${BASEDIR}deploy.sh";

