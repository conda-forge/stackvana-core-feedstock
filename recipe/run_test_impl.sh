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
val=`setup -j pex_exceptions 2>&1`
if [[ ! ${val} ]]; then
    echo "worked!"
else
    echo "failed!"
    exit 1
fi

# try an import
setup pex_exceptions
python -c "import lsst.pex.exceptions"

# latest_rubin_env=$(conda search rubin-env-nosysroot --json | jq -r '."rubin-env-nosysroot"[-1].version')
latest_rubin_env=$(micromamba search rubin-env-nosysroot --json | jq -r '.result.pkgs | sort_by(.timestamp)[-1].version')
curr_rubin_env=$(conda list --json | jq -r '.[] | select(.name == "rubin-env-nosysroot").version')

if [[ "${latest_rubin_env}" != "${curr_rubin_env}" ]]
then
    echo "rubin-env is not up to date!"
    echo "pinned in recipe: ${curr_rubin_env}"
    echo "latest:           ${latest_rubin_env}"
    exit 1
fi
