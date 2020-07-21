#!/bin/bash

# Load script
_deploy_file=$(cat <<EOF
#!/bin/bash

cd "${BASEDIR}${_INSTALL_FOLDER}";
git pull;
git submodule update --init --recursive;
EOF
);

echo "${_deploy_file}" >> "${BASEDIR}deploy.sh";

