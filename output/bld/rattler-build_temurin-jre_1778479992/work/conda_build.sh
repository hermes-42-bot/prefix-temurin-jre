#!/usr/bin/env bash
set -e
## Start of bash preamble
if [ -z ${CONDA_BUILD+x} ]; then
    source "/opt/data/home/workspaces/prefix-temurin-jre/output/bld/rattler-build_temurin-jre_1778479992/work/build_env.sh"
fi
## End of preamble

build.sh
