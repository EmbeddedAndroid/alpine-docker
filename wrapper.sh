#!/usr/bin/env bash
# This is a wrapper script so the create_n_deploy script doesn't need to handle different script behaviours.
# In the end, c_n_d expects a "rootfs.tar.xz" file in its root dir.
set -e
set -u

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
rootfs_dir="$(dirname ${__dir})"

usage(){
echo "There's no use in here."
}


while getopts "ha:o:r:" opt; do
    case $opt in
        a)
            ARCH=$OPTARG
            ;;
        o)
            OS=$OPTARG
            ;;
        r)
            REL=$OPTARG
            ;;
        *)
            usage
            ;;
    esac
done

OS=${OS:-none}

if [ -z "${OS}" ]
then
    exit 1
fi

if [ $REL != "edge" ]; then
	REL=v$REL
fi

if [ $ARCH == "arm64" ]; then
	ARCH=aarch64
fi

export ARCH=${ARCH:-armhf}

bash "${__dir}/mkimage-${OS}.sh" -r ${REL} -s < /dev/null
