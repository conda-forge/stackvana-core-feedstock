import json
import subprocess
import sys

from packaging.version import parse


def _get_curr_rubin_env_version():
    pkgs = json.loads(subprocess.run(
        ["micromamba", "list", "--json"],
        check=True,
        text=True,
        capture_output=True
    ).stdout)
    for pkg in pkgs:
        if pkg["name"] == "rubin-env-nosysroot" and "dev" not in pkg["version"]:
            return parse(pkg["version"])

    raise RuntimeError("Could not find current `rubin-env-nosysroot` version!")


def _get_latest_rubin_env_version():
    pkgs = json.loads(subprocess.run(
        ["micromamba", "search", "rubin-env-nosysroot", "--json"],
        check=True,
        text=True,
        capture_output=True
    ).stdout)["result"]
    max_version = None
    for pkg in pkgs:
         if pkg["name"] == "rubin-env-nosysroot" and "dev" not in pkg["version"]:
            if max_version is None:
                max_version = parse(pkg["version"])
            elif parse(pkg["version"]) > max_version:
                max_version = parse(pkg["version"])

    if max_version is None:
        raise RuntimeError("Could not find latest `rubin-env-nosysroot` version!")

    return max_version


if __name__ == "__main__":
    curr_ver = _get_curr_rubin_env_version()
    latest_ver = _get_latest_rubin_env_version()

    if curr_ver != latest_ver:
        print("rubin-env is not up to date!", flush=True)
        print("pinned in recipe:", curr_ver, flush=True)
        print("latest:          ", latest_ver, flush=True)
        sys.exit(1)
    else:
        sys.exit(0)
