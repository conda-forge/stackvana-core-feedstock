# we have to check if things have not already been activated
if [ -z "${STACKVANA_ACTIVATED}" ]; then
  # shellcheck source=/dev/null
  . "${CONDA_PREFIX}/lsst_home/stackvana_activate.sh"
fi
