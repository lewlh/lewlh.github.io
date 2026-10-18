#!/bin/bash

ARCH=$(uname -m)
arch=amd64

# 判断CPU指令集
case "$ARCH" in
    x86_64)
        # echo "CPU指令集: x86_64 (64-bit)"
        arch=amd64
        ;;
    i686 | i386)
        # echo "CPU指令集: x86 (32-bit)"
        arch=amd64
        ;;
    armv7l)
        # echo "CPU指令集: ARMv7 (32-bit)"
        arch=arm64
        ;;
    aarch64)
        # echo "CPU指令集: ARMv8 (64-bit)"
        arch=arm64
        ;;
    arm64)
        # echo "CPU指令集: ARMv8 (64-bit)"
        arch=arm64
        ;;
    *)
        echo "未知的CPU指令集: $ARCH"
        ;;
esac
echo ${arch}

BASE_IMAGE_NAME=lewlh/hexo-next
BASE_IMAGE_VERSION=20250307-${arch}
DOCKER_IMAGE=${BASE_IMAGE_NAME}:${BASE_IMAGE_VERSION}

export DOCKER_BUILDKIT=1

echo "Base envirement"