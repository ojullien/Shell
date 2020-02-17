#!/bin/bash
## -----------------------------------------------------------------------------
## Linux Scripts.
## Install the bash-pki project into the /opt/oju/bash directory.
##
## @package ojullien\bash-pki\scripts
## @license MIT <https://github.com/ojullien/bash-pki/blob/master/LICENSE>
## -----------------------------------------------------------------------------
#set -o errexit
set -o nounset
set -o pipefail

## -----------------------------------------------------------------------------
## Current project directory, eg: /opt/Shell/scripts/
## -----------------------------------------------------------------------------
readonly m_DIR_REALPATH="$(realpath "$(dirname "$0")")"

## -----------------------------------------------------------------------------
## Defines main directories
## -----------------------------------------------------------------------------
readonly m_SHELL_INSTALL_SOURCE_DIR="$(realpath "${m_DIR_REALPATH}/../src")"
readonly -a m_SHELL_PACKAGES=("sys" "autosave" "autosavedb" "clean" "createdomain" "fillwithzeros" "install" "manageservices" "pki" "savedb" "savesite" "savesystemconf" "tartime" "updatesystem" "version");

## -----------------------------------------------------------------------------
## Install
## -----------------------------------------------------------------------------
for m_Index in "${!m_SHELL_PACKAGES[@]}"
do
    m_Package="${m_SHELL_PACKAGES[$m_Index]}"
    echo "Installing ${m_Package} ..."
    cd "${m_DIR_REALPATH}/../src/${m_Package}/scripts" || exit 1
    bash install.sh "$@"
done
