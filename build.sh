#!/usr/bin/env bash

CUR_DIR=$(dirname $(readlink -f $0 || realpath $0))
DOCKERS_IMAGES='
    opencv2.4-boost1.66-cuda9.1-video
    opencv3.4-boost1.66-python3.6
'

for image in ${DOCKERS_IMAGES}
do
    docker build -t fmigneault/dockers:${image} ${image} | tee ${CUR_DIR}/build.log
done
