#!/usr/bin/env bash

DOCKERS_IMAGES='
    opencv2.4-boost1.66-cuda9.1-video
    opencv3.4-boost1.66-python3.6
'

for image in ${DOCKERS_IMAGES}
do
    docker build -t fmigneault/dockers:${image} ${image}
done
