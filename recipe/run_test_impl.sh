#!/bin/bash
if [[ ! ${LSST_HOME} ]]
then
    echo "LSST_HOME is not set!"
    exit 1
fi

if [[ ! ${STACKVANA_ACTIVATED} ]]
then
    echo "STACKVANA_ACTIVATED is not set!"
    exit 1
fi

echo "
environment:"
env | sort

echo "
eups runs:"
{
    eups -h
} || {
    exit 1
}

echo "
eups list:"
{
    eups list
} || {
    exit 1
}


# this should work
echo "attempting to build 'pex_exceptions' ..."
stackvana-build pex_exceptions
echo " "

echo -n "setting up 'pex_exceptions' ... "
setup pex_exceptions
if [ -n "${PEX_EXCEPTIONS_DIR}" ]; then
    echo "worked!"
    # try an import
    python -c "import lsst.pex.exceptions"
else
    echo "failed!"
    exit 1
fi
# val=$(setup -j pex_exceptions 2>&1)
# if [[ ! ${val} ]]; then
#     echo "worked!"
# else
#     echo "failed!"
#     exit 1
# fi

latest_rubin_env=$(conda search rubin-env-nosysroot --json | jq -r '."rubin-env-nosysroot"[-1].version')
micromamba list --json
curr_rubin_env=$(micromamba list --json | jq -r '.[] | select(.name == "rubin-env-nosysroot").version')

if [[ "${latest_rubin_env}" != "${curr_rubin_env}" ]]
then
    echo "rubin-env is not up to date!"
    echo "pinned in recipe: ${curr_rubin_env}"
    echo "latest:           ${latest_rubin_env}"
    exit 1
fi
