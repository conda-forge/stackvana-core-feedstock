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
if [[ \${LSST_LIBRARY_PATH:-} ]]; then
  if [[ \${DYLD_LIBRARY_PATH:-} ]]; then
    _dyld_extra=\":\${DYLD_LIBRARY_PATH}\"
  else
    _dyld_extra=\"\"
  fi

  if [[ \${DYLD_FALLBACK_LIBRARY_PATH:-} ]]; then
    _dyld_fb_extra=\":\${DYLD_FALLBACK_LIBRARY_PATH}\"
  else
    _dyld_fb_extra=\"\"
  fi

  DYLD_LIBRARY_PATH=\${LSST_LIBRARY_PATH}\${_dyld_extra} \\
  DYLD_FALLBACK_LIBRARY_PATH=\${LSST_LIBRARY_PATH}\${_dyld_fb_extra} \\
  python${pyver}.bak \"\$@\"
else
  python${pyver}.bak \"\$@\"
fi
" > ${CONDA_PREFIX}/bin/python${pyver}
  chmod u+x ${CONDA_PREFIX}/bin/python${pyver}
fi
