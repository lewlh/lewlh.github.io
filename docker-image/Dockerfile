FROM --platform=$BUILDPLATFORM tonistiigi/xx:1.4.0 AS xx
FROM --platform=$BUILDPLATFORM node:22-bookworm-slim AS node
COPY --from=xx / /

RUN npm config set registry https://registry.npmmirror.com
RUN mkdir -p /hexo && cd /hexo
WORKDIR /hexo
RUN npm install hexo-cli -g && npm cache clean -f
COPY package.json package-lock.json /hexo/
RUN npm ci && npm cache clean -f 
RUN apt update && apt install -y git && apt clean -y