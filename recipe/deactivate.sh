if [ -n "${STACKVANA_ACTIVATED}" ]; then
    # shellcheck source=/dev/null
    . "${CONDA_PREFIX}/lsst_home/stackvana_deactivate.sh"
fi
