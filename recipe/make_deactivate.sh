# undo the shim
if [[ `uname -s` == "Darwin" ]]; then
  pyver=$(python -V | cut -d' ' -f2 | cut -d. -f1-2)
  mv ${CONDA_PREFIX}/bin/python${pyver}.bak ${CONDA_PREFIX}/bin/python${pyver}
  # leave behind a symlink just in case this path propagates
  ln -s ${CONDA_PREFIX}/bin/python${pyver} ${CONDA_PREFIX}/bin/python${pyver}.bak
fi
