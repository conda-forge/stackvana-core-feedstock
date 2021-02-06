# this shim is here to bypass SIP for running the OSX tests.
# the conda-build prefixes are very long and so the pytest
# command line tool gets /usr/bin/env put in for the prefix.
# invoking env causes SIP to be invoked and all of the DYLD_LIBRARY_PATHs
# get swallowed. Here we reinsert them right before the python executable.
if [[ `uname -s` == "Darwin" ]]; then
  pyver=$(python -V | cut -d' ' -f2 | cut -d. -f1-2)
  mv ${CONDA_PREFIX}/bin/python${pyver} ${CONDA_PREFIX}/bin/python${pyver}.bak
  echo "\
#!/bin/bash
if [[ \${LSST_LIBRARY_PATH} ]]; then
  DYLD_LIBRARY_PATH=\${LSST_LIBRARY_PATH} \\
  DYLD_FALLBACK_LIBRARY_PATH=\${LSST_LIBRARY_PATH} \\
  python${pyver}.bak \"\$@\"
else
  python${pyver}.bak \"\$@\"
fi
" > ${CONDA_PREFIX}/bin/python${pyver}
  chmod u+x ${CONDA_PREFIX}/bin/python${pyver}
fi
