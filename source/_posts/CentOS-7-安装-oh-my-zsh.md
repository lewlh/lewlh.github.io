---
title: CentOS 7 安装 oh-my-zsh
date: 2020-06-28 17:48:34
tags:
    - centos7
    - oh-my-zsh
---

## 前言

本人比较喜欢使用 `oh-my-zsh` 的 shell 终端，每一次使用新的机器，都要在互联网上搜索一遍安装步骤。趁着这次使用新的 CentOS 7 机器，记录一下安装过程。

<!-- more -->

## 安装步骤

1. 通过 yum 安装 zsh、git、wget：

    ```shell
    yum install -y zsh git wget
    ```

    + oh-my-zsh 依赖于 zsh;
    + git 用来拉取 oh-my-zsh 代码;
    + wget 用来下载 oh-my-zsh 的安装脚本
2. 安装 `oh-my-zsh`:

    ```shell
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
    ```

3. 使用 `which zsh` 查看 zsh 的安装目录，一般都存储在 /usr/bin/zsh 目录下。

    ```shell
    which zsh
    ```

4. 使用 chsh 命令切换使用的 shell 程序:

    ```shell
    chsh -s /usr/bin/zsh
    ```

## 进行可选配置

### 修改主题

+ 编辑 .zshrc 文件

  ```shell
  vi ~/.zshrc
  ```

+ 修改主题类型
  找到 `ZSH_THEME` ,修改主题名称，本人喜欢 *agnoster* 主题，只需要将 `ZSH_THEME` 改为 agnoster 保存：

  ```shell
    ## Set name of the theme to load --- if set to "random", it will
    ## load a random theme each time oh-my-zsh is loaded, in which case,
    ## to know which specific one was loaded, run: echo $RANDOM_THEME
    ## See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
    ZSH_THEME="robbyrussell"
  ```

+ 应用配置文件
  重启shell或者执行一下命令生效：

  ```shell
  source ~/.zshrc
  ```

### 安装插件

使用 ZSH 替换原有的 SHELL 最主要的原因就是要使用其功能强大的插件，下面介绍常用插件。

#### zsh-syntax-highlighting

一款语法高亮插件，详情请看[官网](https://github.com/zsh-users/zsh-syntax-highlighting).

+ 请执行以下命令：

  ```shell
  ## 进入 oh-my-zsh 插件目录
  cd ~/.oh-my-zsh/custom/plugins 

  ## 拉取源码
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

  ## 将 zsh-syntax-highlighting 添加到环境变量中
  echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
  ```

+ 修改 ~/.zshrc 文件,在 `plugins` 中添加 *zsh-syntax-highlighting*：

  ```shell
  ## Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
  ## Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
  ## Example format: plugins=(rails git textmate ruby lighthouse)
  ## Add wisely, as too many plugins slow down shell startup.
  plugins=(
    git
    zsh-syntax-highlighting
  )
  ```

+ 应用配置文件
  重启shell或者执行一下命令生效：

  ```shell
  source ~/.zshrc
  ```

#### zsh-autosuggestions

一款命令自动补全插件，详情请看[官网](https://github.com/zsh-users/zsh-autosuggestions)

+ 请执行以下命令：

  ```shell
  ## 进入 oh-my-zsh 插件目录
  cd ~/.oh-my-zsh/custom/plugins 

  ## 拉取源码
  git clone https://github.com/zsh-users/zsh-autosuggestions.git
  ```

+ 修改 ~/.zshrc 文件,在 `plugins` 中添加 *zsh-autosuggestions*：

  ```shell
  ## Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
  ## Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
  ## Example format: plugins=(rails git textmate ruby lighthouse)
  ## Add wisely, as too many plugins slow down shell startup.
  plugins=(
    git
    zsh-autosuggestions
  )
  ```

+ 应用配置文件
  重启shell或者执行一下命令生效：

  ```shell
  source ~/.zshrc
  ```

#### zsh-history-substring-search

一款查找匹配前缀的历史输入插件，详情请看[官网](https://github.com/zsh-users/zsh-history-substring-search)

+ 请执行以下命令：

  ```shell
  ## 进入 oh-my-zsh 插件目录
  cd ~/.oh-my-zsh/custom/plugins 

  ## 拉取源码
  git clone https://github.com/zsh-users/zsh-history-substring-search.git
  ```

+ 修改 ~/.zshrc 文件,在 `plugins` 中添加 *zsh-history-substring-search*：

  ```shell
  ## Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
  ## Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
  ## Example format: plugins=(rails git textmate ruby lighthouse)
  ## Add wisely, as too many plugins slow down shell startup.
  plugins=(
    git
    history-substring-search
  )
  ```

+ 应用配置文件
  重启shell或者执行一下命令生效：

  ```shell
  source ~/.zshrc
  ```
  