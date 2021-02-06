#!/bin/bash

for CHANGE in "activate" "deactivate"; do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/make_${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
done

cp ${RECIPE_DIR}/stackvana-make ${PREFIX}/bin/stackvana-make
chmod u+x ${PREFIX}/bin/stackvana-make
