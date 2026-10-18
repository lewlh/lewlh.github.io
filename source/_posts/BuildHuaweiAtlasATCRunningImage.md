---
title: 构建在非华为设备上运行的HuaweiAtlasATC镜像
date: 2025-04-02 14:05:32
tags:
    - Atlas 300I Pro
    - ATC
    - DockerImage
---

在 ToG 领域的业务系统，Huawei Atlas NPU 占领了非常大的市场份额，很多公司因各种各样的原因，也纷纷选择兼容 Atlas NPU 的方案。但是，Huawei Atlas NPU 价格并不便宜，很多研发团队在项目开始时通过某些渠道申请到华为的测试机资源，当完成研发测试后，便返还给对方，自己并没有华为的硬件平台。笔者遇到了一个问题，就是项目中使用到的 om 模型，推理出来的结果有问题，需要重新使用 ATC 工具对 onnx 模型进行重新转换。但是在我们研发的资源里面，并没有华为平台的硬件资源，没法使用华为公开的镜像运行 ATC 命令行工具。本文将介绍如何构建一个在非华为设备上运行 ATC 命令行工具的镜像。

<!-- more -->

**********

按照华为的 Cann 官方文档，我选择以下基本的构建程序包：

+ [ubuntu:18.04镜像](https://hub.docker.com/layers/library/ubuntu/18.04/images/sha256-fc896f56642f382e99601461c683dee1534f0d4cb7e17bcb3494d5ed0f3a8a06)
+ [Ascend-cann-toolkit_8.0.0_linux-x86_64.run](https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/CANN/CANN%208.0.0/Ascend-cann-toolkit_8.0.0_linux-x86_64.run?response-content-type=application/octet-stream)

为了简化构建的复杂度，本次我没有使用 Dockerfile 构建镜像，而是直接使用 ubuntu:18.04 镜像启动容器，在容器内进行依赖安装。

+ 启动容器 `docker run -it --name huaweiATC ubuntu:18.04 /bin/bash`
+ 更新apt源：
  
  ```bash
  apt-get update

  apt-get install -y ca-certificates vim

  # 备份apt源文件 
  cp /etc/apt/sources.list /etc/apt/sources.list_backup

  # 修改apt源文件
  vim /etc/apt/sources.list

  # 注释或删除原来的源并添加一下阿里源地址, 保存退出
  deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
  deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
  deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
  deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
  deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
  deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
  deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
  deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
  deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
  deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse

  # 刷新列表
  apt-get update
  apt-get upgrade
  apt-get install build-essential
  ```

+ 参考[安装依赖（Ubuntu 18.04）](https://www.hiascend.com/document/detail/zh/canncommercial/601/envdeployment/instg/instg_000023.html)，安装相关依赖：
  + 使用 apt-get 安装依赖：
  
  ```bash
  apt-get install -y cmake make gcc g++ zlib1g zlib1g-dev libsqlite3-dev openssl libssl-dev libffi-dev unzip pciutils net-tools libblas-dev gfortran libblas3 liblapack-dev liblapack3
  ```
  
  + 安装 python3.8

  ```bash
  # 添加 deadsnakes PPA
  apt-get install -y software-properties-common
  add-apt-repository ppa:deadsnakes/ppa
  apt-get update

  # 安装 Python 3.8
  apt-get install -y python3.8 python3.8-dev python3.8-distutils

  # 设置 Python 3.8 为默认版本
  update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1

  # 验证默认版本
  python3 --version

  # 安装 pip
  apt-get install -y python3-pip
  python3.8 -m pip install --upgrade pip

  # 检查 pip 版本
  python3 -m pip --version

  # 使用 pip 安装其他依赖
  pip install attrs pyyaml pathlib2 scipy requests psutil absl-py protobuf cffi sympy decorator numpy -i https://pypi.tuna.tsinghua.edu.cn/simple
  ```

+ 安装开发套件包
  + 将下载的`Ascend-cann-toolkit_8.0.0_linux-x86_64.run`文件上传到容器中:
  
  ```bash
  docker cp Ascend-cann-toolkit_8.0.0_linux-x86_64.run huaweiATC:/root/
  ```
  
  在容器内执行以下命令安装开发套件包：

  ```bash
  chmod +x /root/Ascend-cann-toolkit_8.0.0_linux-x86_64.run
  /root/Ascend-cann-toolkit_8.0.0_linux-x86_64.run --full

  # 安装完成后输出的日志
  ===========
  = Summary =
  ===========
  
  Driver:   Not installed.
  Toolkit:  Ascend-cann-toolkit_8.0.0_linux-x86_64 install success, installed in /usr/local/Ascend.
  
  Please make sure that the environment variables have been configured.
  -  To take effect for current user, you can exec command below: source /usr/local/Ascend/ascend-toolkit/set_env.sh or add "source /usr/local/Ascend/ascend-toolkit/set_env.sh" to ~/.bashrc.
  ```

+ 配置环境变量: `vim ~/.bashrc`

  ```bash
  # 添加以下内容
  export LD_LIBRARY_PATH=/usr/lib/python3.8/:$LD_LIBRARY_PATH
  export LD_LIBRARY_PATH=/usr/local/Ascend/ascend-toolkit/latest/x86_64-linux/devlib/:$LD_LIBRARY_PATH
  source /usr/local/Ascend/ascend-toolkit/set_env.sh
  ```

+ 验证环境变量是否配置成功：

  ```bash
  # 使环境变量立即生效
  source ~/.bashrc

  # 执行 atc 命令
  atc --help
  
  # 输出的部分日志
  ATC start working now, please wait for a moment.
  usage: atc <args>
  generate offline model example:
  atc --model=./alexnet.prototxt --weight=./alexnet.caffemodel --framework=0 --output=./domi --soc_version=<soc_version>
  generate offline model for single op example:
  atc --singleop=./op_list.json --output=./op_model --soc_version=<soc_version>

  ......
  ```

+ 导出容器为镜像

  ```bash
  # 退出容器。此时容器会停止运行，但不会被删除。
  exit

  # 在容器外，查看容器的ID
  docker ps -a

  CONTAINER ID   IMAGE          COMMAND       CREATED        STATUS                     PORTS     NAMES
  fa5a7f34f49f   ubuntu:18.04   "/bin/bash"   24 hours ago   Exited (0) 2 seconds ago             huaweiATC

  # 导出容器为镜像
  docker commit fa5a7f34f49f huawei_atc:20250403

  # 查看导出的镜像
  docker images

  REPOSITORY                           TAG        IMAGE ID       CREATED         SIZE
  huawei_atc                           20250403   399617f094e3   2 minutes ago   9.54GB
  ```

+ 运行新镜像

  ```bash
  docker run -it huawei_atc:20250403 /bin/bash

  root@e47ce996e168:/# atc --help
  ATC start working now, please wait for a moment.
  usage: atc <args>
  generate offline model example:
  atc --model=./alexnet.prototxt --weight=./alexnet.caffemodel --framework=0 --output=./domi --soc_version=  <soc_version>
  generate offline model for single op example:
  atc --singleop=./op_list.json --output=./op_model --soc_version=<soc_version>
  
  ===== Basic Functionality =====
  
  ......
  ```

## Reference

+ [在非昇腾设备上安装 Cann](https://www.hiascend.com/document/detail/zh/canncommercial/601/envdeployment/instg/instg_000027.html)
+ [Ascend社区资源下载](https://www.hiascend.com/developer/download/community/result?module=pt+cann&product=2&model=15)