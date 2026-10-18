#!/bin/bash
source ~/workspace/hexo/scripts-lewlh/base_env.sh

if [ "$#" -ne 1 ]; then
    echo "usage: bash start.sh <BLOG_PATH>"
    exit 1
fi

BLOG_PATH=$1
CONTAINER_NAME=lewlh-hexo-next

docker stop ${CONTAINER_NAME} || true
docker rm ${CONTAINER_NAME} || true

# NOTE: 本地容器部署已废弃（改用 GitHub Actions）。保留此脚本仅供本地构建参考。
# 不要使用 --restart=unless-stopped：一旦构建失败会导致容器无限重启，
# 每次重启都会 force push 并触发一次 GitHub Pages 构建，形成死循环。
docker run --rm --name ${CONTAINER_NAME} \
       -w /hexo \
       -v ${BLOG_PATH}/scaffolds:/hexo/scaffolds \
       -v ${BLOG_PATH}/source:/hexo/source \
       -v ${BLOG_PATH}/themes:/hexo/themes \
       -v ${BLOG_PATH}/_config.next.yml:/hexo/_config.next.yml \
       -v ${BLOG_PATH}/_config.yml:/hexo/_config.yml \
       -v ${HOME}/.ssh:/root/.ssh \
       ${DOCKER_IMAGE} bash -c "rm -rf .deploy_git public || true && hexo clean && hexo generate && hexo deploy"