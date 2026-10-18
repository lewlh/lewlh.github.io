#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "usage: bash build_docker.sh <1.0.0|2.0.0|dev|test>"
    exit 1
fi

ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then
    ARCH=arm64
elif [ "$(uname -m)" = "arm64" ]; then
    ARCH=arm64
else
    ARCH=amd64
fi

TAG=$1-$ARCH
BUILDPLATFORM=linux/$ARCH

cp -r ../package.json ../package-lock.json .

# docker buildx build --no-cache -t lewlh/hexo-next:$1  .

docker buildx build -t lewlh/hexo-next:$TAG --platform $BUILDPLATFORM \
       --build-arg BUILDPLATFORM=$BUILDPLATFORM --network=host .