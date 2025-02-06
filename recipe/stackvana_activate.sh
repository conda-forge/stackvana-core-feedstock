#!/bin/sh

# note that before calling this script, you must check that eups has not already
# been activated. for example, the conda activate script for stackvana-core is
#
#     if [[ ! ${STACKVANA_ACTIVATED} ]]; then
#         source ${CONDA_PREFIX}/lsst_home/stackvana_activate.sh
#     fi
#

# a flag to indicate stackvana is activated
export STACKVANA_ACTIVATED=1

# clean/backup any EUPS stuff
export STACKVANA_BACKUP_EUPS_PKGROOT="${EUPS_PKGROOT}"
export EUPS_PKGROOT="https://eups.lsst.codes/stack/src"

# backup the LD paths since the DM stack will muck with them
export STACKVANA_BACKUP_LD_LIBRARY_PATH="${LD_LIBRARY_PATH}"
export STACKVANA_BACKUP_DYLD_LIBRARY_PATH="${DYLD_LIBRARY_PATH}"
export STACKVANA_BACKUP_LSST_LIBRARY_PATH="${LSST_LIBRARY_PATH}"

# instruct sconsUtils to use the conda compilers
export STACKVANA_BACKUP_SCONSUTILS_USE_CONDA_COMPILERS="${SCONSUTILS_USE_CONDA_COMPILERS}"
export SCONSUTILS_USE_CONDA_COMPILERS=1

# finally setup env so we can build packages
stackvana_backup_and_append_envvar() {
    _way="$1"
    _envvar="$2"

    if [ "${_way}" = "activate" ]; then
        _appval="$3"
        _appsep="$4"
        eval oldval="\$${_envvar}"

        eval "export STACKVANA_BACKUP_${_envvar}=\"${oldval}\""
        if [ -z "${oldval}" ]; then
            eval "export ${_envvar}=\"${_appval}\""
        else
            eval "export ${_envvar}=\"${oldval}${_appsep}${_appval}\""
        fi
    else
        eval backval="\$STACKVANA_BACKUP_${_envvar}"

        if [ -z "${backval}" ]; then
            eval "unset ${_envvar}"
        else
            eval "export ${_envvar}=\"${backval}\""
        fi
        eval "unset STACKVANA_BACKUP_${_envvar}"
    fi
}
