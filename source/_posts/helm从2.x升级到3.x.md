---
title: helm从2.x升级到3.x
date: 2020-09-09 19:29:48
tags:
    - helm
    - k8s
    - Kubernetes
---

![helm](https://helm.sh/img/helm.svg)

我们使用了 [kubeasz](https://github.com/easzlab/kubeasz) 初始化了一套 Kubernetes 集群，基本上按照该[指南](https://github.com/easzlab/kubeasz/blob/master/docs/setup/00-planning_and_overall_intro.md)执行相关步骤，安装上了相关组件，其中包括 helm。后续使用我们发现该 ansible 脚本安装的是 helm 2.x 版本，这时 helm 3.x 已经正式上线了。为了日后学习、使用方便，我决定将 helm 升级。本文将记录升级的过程。

<!-- more -->

## 原状

1. 系统是 debian 10：

    ```bash
    root@debian  /home/debian/helm  uname -a
    Linux debian 4.19.0-10-amd64 #1 SMP Debian 4.19.132-1 (2020-07-24) x86_64 GNU/Linux
    ```

2. helm 的版本是 v2.14.1：

    ```bash
    root@debian  /home/debian/helm  helm version
    Client: &version.Version{SemVer:"v2.14.1", GitCommit:"5270352a09c7e8b6e8c9593002a73535276507c0", GitTreeState:"clean"}
    Server: &version.Version{SemVer:"v2.14.3", GitCommit:"0e7f3b6637f7af8fcfddb3d2941fcc7cbebb0085", GitTreeState:"clean"}
    ```

## 安装 helm 3.x

使用[官网安装教程](https://helm.sh/docs/intro/install/)提供的安装步骤:

```bash
# From Apt (Debian/Ubuntu)
# Members of the Helm community have contributed a Helm package for Apt. This package is generally up to date.
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```

安装完成后，使用 oh-my-zsh 的服务器，helm 命令依然是 2.x 版本，也无法识别 helm3 命令，但是使用 bash 的服务器无此问题。修改 `~/.zshrc` 文件，让使用 oh-my-zsh 的服务器使用 helm3：

```bash
$ echo "alias helm3='/usr/bin/helm'" >> ~/.zshrc && source ~/.zshrc

$ helm3 version
version.BuildInfo{Version:"v3.3.1", GitCommit:"249e5215cde0c3fa72e27eb7a30e8d55c9696144", GitTreeState:"clean", GoVersion:"go1.14.7"}

$ helm version
Client: &version.Version{SemVer:"v2.14.1", GitCommit:"5270352a09c7e8b6e8c9593002a73535276507c0", GitTreeState:"clean"}
could not read x509 key pair (cert: "/home/debian/.helm/cert.pem", key: "/home/debian/.helm/key.pem"): can't load key pair from cert /home/debian/.helm/cert.pem and key /home/debian/.helm/key.pem: open /home/debian/.helm/cert.pem: no such file or directory
```

## Helm V2 迁移到 V3

### 安装 helm-2to3 插件

安装插件：

```bash
helm3 plugin install https://github.com/helm/helm-2to3
```

确认是否安装成功

```bash
$ helm3 plugin list
NAME    VERSION DESCRIPTION
2to3    0.6.0   migrate and cleanup Helm v2 configuration and releases in-place to Helm v3

$ helm3 2to3
Migrate and Cleanup Helm v2 configuration and releases in-place to Helm v3

Usage:
  2to3 [command]

Available Commands:
  cleanup     cleanup Helm v2 configuration, release data and Tiller deployment
  convert     migrate Helm v2 release in-place to Helm v3
  help        Help about any command
  move        migrate Helm v2 configuration in-place to Helm v3

Flags:
  -h, --help   help for 2to3

Use "2to3 [command] --help" for more information about a command.
```

### 迁移

#### 迁移 configuration

查看帮助信息：

```bash
$ helm3 2to3 move config -h
migrate Helm v2 configuration in-place to Helm v3

Usage:
  2to3 move config [flags]

Flags:
      --dry-run   simulate a command
  -h, --help      help for move
```

执行迁移：

```bash
$ helm3 2to3 move config
2020/09/10 11:09:20 WARNING: Helm v3 configuration may be overwritten during this operation.
2020/09/10 11:09:20
[Move Config/confirm] Are you sure you want to move the v2 configuration? [y/N]: y
2020/09/10 11:09:23
Helm v2 configuration will be moved to Helm v3 configuration.
2020/09/10 11:09:23 [Helm 2] Home directory: /root/.helm
2020/09/10 11:09:23 [Helm 3] Config directory: /root/.config/helm
2020/09/10 11:09:23 [Helm 3] Data directory: /root/.local/share/helm
2020/09/10 11:09:23 [Helm 3] Cache directory: /root/.cache/helm
2020/09/10 11:09:23 [Helm 3] Create config folder "/root/.config/helm" .
2020/09/10 11:09:23 [Helm 3] Config folder "/root/.config/helm" created.
2020/09/10 11:09:23 [Helm 2] repositories file "/root/.helm/repository/repositories.yaml" will copy to [Helm 3] config folder "/root/.config/helm/repositories.yaml" .
2020/09/10 11:09:23 [Helm 2] repositories file "/root/.helm/repository/repositories.yaml" copied successfully to [Helm 3] config folder "/root/.config/helm/repositories.yaml" .
2020/09/10 11:09:23 [Helm 3] Create cache folder "/root/.cache/helm" .
2020/09/10 11:09:23 [Helm 3] cache folder "/root/.cache/helm" created.
2020/09/10 11:09:23 [Helm 3] Create data folder "/root/.local/share/helm" .
2020/09/10 11:09:23 [Helm 3] data folder "/root/.local/share/helm" created.
2020/09/10 11:09:23 [Helm 2] starters "/root/.helm/starters" will copy to [Helm 3] data folder "/root/.local/share/helm/starters" .
2020/09/10 11:09:23 [Helm 2] starters "/root/.helm/starters" copied successfully to [Helm 3] data folder "/root/.local/share/helm/starters" .
2020/09/10 11:09:23 Helm v2 configuration was moved successfully to Helm v3 configuration.
```

#### 迁移 release

可以使用 2to3 插件的 convert 指令迁移 helm2 的 release， 通过 `helm3 2to3 convert --help` 获取该指令的说明：

```bash
$ helm3 2to3 convert --help
migrate Helm v2 release in-place to Helm v3

Usage:
  2to3 convert [flags] RELEASE

Flags:
      --delete-v2-releases         v2 release versions are deleted after migration. By default, the v2 release versions are retained
      --dry-run                    simulate a command
  -h, --help                       help for convert
      --kube-context string        name of the kubeconfig context to use
      --kubeconfig string          path to the kubeconfig file
  -l, --label string               label to select Tiller resources by (default "OWNER=TILLER")
  -s, --release-storage string     v2 release storage type/object. It can be 'secrets' or 'configmaps'. This is only used with the 'tiller-out-cluster' flag (default "secrets")
      --release-versions-max int   limit the maximum number of versions converted per release. Use 0 for no limit (default 10)
  -t, --tiller-ns string           namespace of Tiller (default "kube-system")
      --tiller-out-cluster         when  Tiller is not running in the cluster e.g. Tillerless
```

helm2 中已经存在的 release

```bash
$ helm list
NAME                            REVISION        UPDATED                         STATUS          CHART                   APP VERSION     NAMESPACE
gitlab-runner                   2               Thu Aug 20 19:51:54 2020        DEPLOYED        gitlab-runner-0.13.1    12.7.1          frontend
gitlab-runner-moqi-id           1               Fri Aug 21 00:27:28 2020        DEPLOYED        gitlab-runner-0.13.1    12.7.1          frontend
gitlab-runner-moqi-id-website   2               Fri Aug 21 19:18:24 2020        DEPLOYED        gitlab-runner-0.13.1    12.7.1          frontend
moqi-id-docs                    1               Fri Aug 21 20:45:53 2020        DEPLOYED        gitlab-runner-0.13.1    12.7.1          frontend
moqi-id-website                 1               Fri Aug 21 19:31:06 2020        DEPLOYED        gitlab-runner-0.13.1    12.7.1          frontend
```


helm3 中已经存在的 release

```bash
$ helm3 list -A
NAME    NAMESPACE       REVISION        UPDATED STATUS  CHART   APP VERSION
```

选一个用 `--dry-run` 试下效果:

```bash
$ helm3 2to3 convert gitlab-runner --dry-run
2020/09/10 14:03:48 NOTE: This is in dry-run mode, the following actions will not be executed.
2020/09/10 14:03:48 Run without --dry-run to take the actions described below:
2020/09/10 14:03:48
2020/09/10 14:03:48 Release "gitlab-runner" will be converted from Helm v2 to Helm v3.
2020/09/10 14:03:48 [Helm 3] Release "gitlab-runner" will be created.
2020/09/10 14:03:48 [Helm 3] ReleaseVersion "gitlab-runner.v1" will be created.
2020/09/10 14:03:48 [Helm 3] ReleaseVersion "gitlab-runner.v2" will be created.
```

没有报错，去掉 --dry-run 执行迁移:

```bash
$ helm3 2to3 convert gitlab-runner
2020/09/10 14:10:31 Release "gitlab-runner" will be converted from Helm v2 to Helm v3.
2020/09/10 14:10:31 [Helm 3] Release "gitlab-runner" will be created.
2020/09/10 14:10:32 [Helm 3] ReleaseVersion "gitlab-runner.v1" will be created.
2020/09/10 14:10:32 [Helm 3] ReleaseVersion "gitlab-runner.v1" created.
2020/09/10 14:10:32 [Helm 3] ReleaseVersion "gitlab-runner.v2" will be created.
2020/09/10 14:10:32 [Helm 3] ReleaseVersion "gitlab-runner.v2" created.
2020/09/10 14:10:32 [Helm 3] Release "gitlab-runner" created.
2020/09/10 14:10:32 Release "gitlab-runner" was converted successfully from Helm v2 to Helm v3.
2020/09/10 14:10:32 Note: The v2 release information still remains and should be removed to avoid conflicts with the migrated v3 release.
2020/09/10 14:10:32 v2 release information should only be removed using `helm 2to3` cleanup and when all releases have been migrated over.
```

迁移之后，查看迁移结果：

```bash
$ helm3 list -A
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
gitlab-runner   frontend        2               2020-08-20 11:51:54.75041113 +0000 UTC  deployed        gitlab-runner-0.13.1    12.7.1
```

### 清理 Helm V2 相关数据

官方文档表示，该步骤不是必须的，但却是强烈推荐的。

helm-2to3 提供了清理的命令：

```shell
$ helm3 2to3 cleanup -h
cleanup Helm v2 configuration, release data and Tiller deployment

Usage:
  2to3 cleanup [flags]

Flags:
      --config-cleanup           if set, configuration cleanup performed
      --dry-run                  simulate a command
  -h, --help                     help for cleanup
  -l, --label string             label to select Tiller resources by (default "OWNER=TILLER")
      --release-cleanup          if set, release data cleanup performed
  -s, --release-storage string   v2 release storage type/object. It can be 'secrets' or 'configmaps'. This is only used with the 'tiller-out-cluster' flag (default "secrets")
      --tiller-cleanup           if set, Tiller cleanup performed
  -t, --tiller-ns string         namespace of Tiller (default "kube-system")
      --tiller-out-cluster       when  Tiller is not running in the cluster e.g. Tillerless
```

该命令将会清理以下数据：

+ helm2 的配置文件 Configuration (Helm home directory)
+ v2 的发版数据 v2 release data
+ Tiller deployment
 
使用 --dry-run 查看执行该命令会执行哪些操作：

```shell
$ helm3 2to3 cleanup --dry-run
2020/09/10 14:50:57 NOTE: This is in dry-run mode, the following actions will not be executed.
2020/09/10 14:50:57 Run without --dry-run to take the actions described below:
2020/09/10 14:50:57
WARNING: "Helm v2 Configuration" "Release Data" "Tiller" will be removed.
This will clean up all releases managed by Helm v2. It will not be possible to restore them if you haven't made a backup of the releases.
Helm v2 may not be usable afterwards.

[Cleanup/confirm] Are you sure you want to cleanup Helm v2 data? [y/N]: y
2020/09/10 14:51:17
Helm v2 data will be cleaned up.
2020/09/10 14:51:17 [Helm 2] Releases will be deleted.
2020/09/10 14:51:18 [Helm 2] ReleaseVersion "gitlab-runner-moqi-id-website.v1" will be deleted.
2020/09/10 14:51:18 [Helm 2] ReleaseVersion "moqi-id-website.v1" will be deleted.
2020/09/10 14:51:18 [Helm 2] ReleaseVersion "gitlab-runner-moqi-id.v1" will be deleted.
2020/09/10 14:51:18 [Helm 2] ReleaseVersion "gitlab-runner.v1" will be deleted.
2020/09/10 14:51:18 [Helm 2] ReleaseVersion "hello-world.v1" will be deleted.
2020/09/10 14:51:18 [Helm 2] ReleaseVersion "moqi-id-docs.v1" will be deleted.
2020/09/10 14:51:18 [Helm 2] ReleaseVersion "gitlab-runner.v2" will be deleted.
2020/09/10 14:51:18 [Helm 2] ReleaseVersion "gitlab-runner-moqi-id-website.v2" will be deleted.
2020/09/10 14:51:18 [Helm 2] Tiller in "kube-system" namespace will be removed.
2020/09/10 14:51:18 [Helm 2] Home folder "/home/debian/.helm" will be deleted.
```

如果确认没有问题，可以正式执行：

```shell
$ helm3 2to3 cleanup
WARNING: "Helm v2 Configuration" "Release Data" "Tiller" will be removed.
This will clean up all releases managed by Helm v2. It will not be possible to restore them if you haven't made a backup of the releases.
Helm v2 may not be usable afterwards.

[Cleanup/confirm] Are you sure you want to cleanup Helm v2 data? [y/N]: y
2020/09/10 14:54:59
Helm v2 data will be cleaned up.
2020/09/10 14:54:59 [Helm 2] Releases will be deleted.
2020/09/10 14:55:00 [Helm 2] ReleaseVersion "gitlab-runner-moqi-id-website.v1" will be deleted.
2020/09/10 14:55:00 [Helm 2] ReleaseVersion "gitlab-runner-moqi-id-website.v1" deleted.
2020/09/10 14:55:00 [Helm 2] ReleaseVersion "moqi-id-website.v1" will be deleted.
2020/09/10 14:55:01 [Helm 2] ReleaseVersion "moqi-id-website.v1" deleted.
2020/09/10 14:55:01 [Helm 2] ReleaseVersion "gitlab-runner-moqi-id.v1" will be deleted.
2020/09/10 14:55:01 [Helm 2] ReleaseVersion "gitlab-runner-moqi-id.v1" deleted.
2020/09/10 14:55:01 [Helm 2] ReleaseVersion "gitlab-runner.v1" will be deleted.
2020/09/10 14:55:02 [Helm 2] ReleaseVersion "gitlab-runner.v1" deleted.
2020/09/10 14:55:02 [Helm 2] ReleaseVersion "hello-world.v1" will be deleted.
2020/09/10 14:55:02 [Helm 2] ReleaseVersion "hello-world.v1" deleted.
2020/09/10 14:55:02 [Helm 2] ReleaseVersion "moqi-id-docs.v1" will be deleted.
2020/09/10 14:55:03 [Helm 2] ReleaseVersion "moqi-id-docs.v1" deleted.
2020/09/10 14:55:03 [Helm 2] ReleaseVersion "gitlab-runner.v2" will be deleted.
2020/09/10 14:55:03 [Helm 2] ReleaseVersion "gitlab-runner.v2" deleted.
2020/09/10 14:55:03 [Helm 2] ReleaseVersion "gitlab-runner-moqi-id-website.v2" will be deleted.
2020/09/10 14:55:04 [Helm 2] ReleaseVersion "gitlab-runner-moqi-id-website.v2" deleted.
2020/09/10 14:55:04 [Helm 2] Releases deleted.
2020/09/10 14:55:04 [Helm 2] Tiller in "kube-system" namespace will be removed.
2020/09/10 14:55:04 [Helm 2] Tiller "deploy" in "kube-system" namespace will be removed.
2020/09/10 14:55:05 [Helm 2] Tiller "deploy" in "kube-system" namespace was removed successfully.
2020/09/10 14:55:05 [Helm 2] Tiller "service" in "kube-system" namespace will be removed.
2020/09/10 14:55:06 [Helm 2] Tiller "service" in "kube-system" namespace was removed successfully.
2020/09/10 14:55:06 [Helm 2] Tiller in "kube-system" namespace was removed.
2020/09/10 14:55:06 [Helm 2] Home folder "/home/debian/.helm" will be deleted.
2020/09/10 14:55:06 [Helm 2] Home folder "/home/debian/.helm" deleted.
2020/09/10 14:55:06 Helm v2 data was cleaned up successfully.
```

**Reference**：[How to migrate from Helm v2 to Helm v3](https://helm.sh/blog/migrate-from-helm-v2-to-helm-v3/)