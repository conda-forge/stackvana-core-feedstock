#!/bin/sh

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

# clean out our stuff - no need to backup or restore
unset STACKVANA_ACTIVATED

# remove stackvana env changes
for var in LSST_HOME LSST_PYVER LSST_DM_TAG \
        LD_LIBRARY_PATH DYLD_LIBRARY_PATH \
        LSST_LIBRARY_PATH \
        SCONSUTILS_USE_CONDA_COMPILERS \
        EUPS_PKGROOT; do
    stackvana_backup_and_append_envvar \
        deactivate \
        "$var"
done
