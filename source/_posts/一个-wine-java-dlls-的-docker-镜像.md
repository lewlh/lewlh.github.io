---
title: 一个 Wine + Java + Dlls 的 Docker 镜像
date: 2020-06-06 18:00:00
tags:
    - wine
    - docker
    - container
    - java
    - jre
    - jdk
---

我有一个 java 项目，需要在 windows 环境下调用第三方的动态链接库 dll 去解析数据，之前一直使用 windows server 2016 + docker + windows container 的方案运行。这个方案能解决第三方dll不能并行运行的问题，可以在一台机器上部署多个 instance。但是由于 windows server 2016 一直是使用虚拟机安装，导致该服务的性能不佳，而且也依赖 windows server 2016 及更高版本的系统。最近我制作了一个 wine + java + dlls 的 docker 镜像，让该 java 项目直接运行在 linux 的容器中，提高了性能，减少了服务器成本。本文介绍该镜像的制作细节。

<!-- more -->

### 构建镜像

本镜像基于 `ubuntu:18.04` 构建, Dockfile 源码如下：

```docker
FROM ubuntu:18.04

COPY sources-http.list /etc/apt/sources.list
RUN apt-get update && apt-get install -y apt-transport-https ca-certificates
COPY sources-https.list /etc/apt/sources.list

RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y wine32 && \
  apt-get clean -y

COPY jdk-8u172-windows-i586.exe /app/jdk.exe
RUN chmod +x /app/jdk.exe && wine /app/jdk.exe /s && rm /app/jdk.exe
ARG target="/root/.wine/drive_c/Program Files/Java/jre1.8.0_172/bin/"
COPY ./dlls/ ${target}

WORKDIR /root
```

我们需要自行准备以下文件：

+ sources-http.list, http 安装源链接,为了加快镜像编译速度:

  ```
    # 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
    deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
    # deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
    deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
    # deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
    deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
    # deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
    deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse
    # deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse

    # 预发布软件源，不建议启用
    # deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse
    # deb-src http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse
  ```

+ sources-https.list, https 安装源链接,为了加快镜像编译速度:

  ```bash
    # 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
    deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
    # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
    deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
    # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
    deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
    # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
    deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse
    # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse

    # 预发布软件源，不建议启用
    # deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse
    # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse
  ```

+ jdk-8u172-windows-i586.exe, jdk安装包，其他版本的jdk需要自行验证是否能正确安装;
+ 依赖的动态链接库 .dll 文件，将这些文件复制到 Dockerfile 所在目录的 dlls 文件下;

准备完成后，文件结构如下：

```bash
.
├── Dockerfile
├── jdk-8u172-windows-i586.exe
├── dlls
├── sources-http.list
└── sources-https.list
```

在此目录下，执行以下命令，编译镜像：

```bash
docker build -t wine-java-dlls:test --network=host . 
```

成功编译后，我们将得到镜像 `wine-java-dlls:test `。

### 使用镜像

通过 wine 执行 java,目前该镜像需要直接声明 java.exe 在 wine 中的路径,使用示例如下:

```bash
docker run -d --net=host --name example --init -w /app -v /root/path/to/jar/location:/app wine-java-dlls:test wine "C:\\Program Files\\Java\\jre1.8.0_172\\bin\\java.exe" -jar test.jar
```

**参考阅读：**
[《Use wine to run windows JDK on linux》](https://kupczynski.info/2018/11/11/wine-windows-jdk-on-linux.html)