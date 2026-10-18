---
title: 构建私有LLM代码助手
date: 2025-02-16 12:00:53
tags:
    - Ollama
    - PageAssist
    - CodeLLM
    - code2prompt
---

本门描述一个简单且闭环的构建私有LLM代码助手的方案。

<!-- more -->

**********

作为程序员，使用LLM之后，确实大幅提升了解决问题的效率。各种免费的LLM服务某种程度上已经替代了搜索引擎，我通常使用问答的方式，很快就能找到问题的答案。但是，互联网上提供的免费LLM服务，我们提供问题上下文的时候，难免会提供具体的功能/业务信息，这里就设计到隐私/保密的问题。无论是国内的还是国外的LLM服务，在我看来都是不可信的，那么有些时候，一些敏感的代码，业务数据以及个人信息，我都会有意识的避免提交到问题的描述/上下文中。随着 Ollama 这些 LLM 基础设施的不断完善，使用个人/企业的服务器资源搭建私有的 LLM 已经非常便利，所以我也尝试构建私有LLM代码助手，本文作为此次构建的记录。

## 总体思路

需求其实很明确，部署一个私有的无审查的 LLM 模型，同时使用开源的大预言模型 UI 工具用于日常的问题对话，在编码工具中安装可调用私有部署的LLM的插件，用于编码过程中的问题解答。另外，对于一些项目级的代码问题，我们需要将项目中的代码整理成一个文件，提交给大语言模型进行分析对话。根据我的调研，本次部署的程序分别有：

+ Ollama：用于部署不同的大语言模型。
+ PageAssist：是一款开源浏览器扩展程序，可为您的本地 AI 模型提供侧边栏和 Web UI。它允许您从任何网页与您的模型进行交互。
+ [code2prompt](https://github.com/mufeedvh/code2prompt)：是一个命令行工具 (CLI)，它可以将您的代码库转换为具有源树、提示模板和标记计数的单个 LLM 提示。
+ CodeLLM：一个 Visual Studio Code 插件，扩展与大语言模型集成，提供离线和在线功能。它旨在简化直接在编辑器中生成代码或回答查询的过程。

## 部署Ollama

Ollama 的出现极大地简化了 LLM 部署的流程，他提供的 Docker 部署方案，对于开发者而言基本上就是一行 docker 命令就把程序跑起来了。当然实际部署可能复杂一些，还需要考虑模型文件的管理,单个实例的负载以及服务伸缩等问题。我恰好有 kubernetes 集群以及一些闲置的 GTX1080Ti/RTX2080Ti 的显卡资源，因此我是使用 helm chart 进行 Ollama 部署的。该 [helm chart](https://github.com/lewlh/share/tree/main/helm-chart/ollama)，提供了以下功能：

+ 提供 autoscaling 功能，根据负载自动伸缩实例数量；
+ 提供 NodePort 类型的服务，方便在集群外访问；
+ 使用 [envoyproxy](https://www.envoyproxy.io/) 提供访问的负载均衡；
+ 通过本地化目录挂载的方式，将模型文件挂载到容器中，避免了模型文件的重复下载。

```bash
# 使用 helm 安装 ollama 服务
❯ helm upgrade --install ollama ollama

# 查看 pod 状态
❯ kubectl get pod | grep ollama        
ollama-7b784f57c8-7rdrp                                    1/1     Running                 0                3m11s
ollama-proxy-64465c96bf-bq5wl                              1/1     Running                 0                3m11s
```

启动成功后，通过 NodePort 的访问地址访问，可以看到 `Ollama is running`。

## 安装PageAssist

PageAssist 是一款浏览器扩展程序，Chrome 浏览器可以直接访问[chrome应用商店](https://chromewebstore.google.com/detail/page-assist-%E6%9C%AC%E5%9C%B0-ai-%E6%A8%A1%E5%9E%8B%E7%9A%84-web/jfgfiigpkhlkbnfnbobbkinehhfdhndo)安装。安装完成后，只需要简单配置，即可使用私有化部署的 Ollama 服务。

+ 打开浏览器扩展程序，点击 `PageAssist` 图标，进入插件页面；
+ 点击右上角齿轮状的设置按钮，进入设置页面；
+ 默认就进入 **General Settings** 页面：
  + 点击 **Speech Recognition Language** 下拉框，选择 `中文（普通话 中国大陆）`；
  + 点击 **Language** 下拉框，选择 `简体中文`；设置完成后，插件的语言就变成简体中文了；
+ 在左侧导航栏点击 **Ollama设置** 选项卡，进入配置 Ollama 页面；
  + 设置 Ollama URL，将上一节通过 helm 安装的 ollama 服务 NodePort 的访问地址填入，并保存；
  + 点击左上角的 **新聊天** 按钮，出现一个新的聊天窗口，窗口中如果显示 `Ollama正在运行` 的提示窗口，说明配置成功。

至此，我们就可以在浏览器中使用私有化部署的LLM服务了。PageAssist 具体的使用方式，如如何选择不同的模型，如何设置 prompt，请读者自行在互联网上查找、尝试，本文不再展开。

## 在VisualStudioCode安装使用Codellm

在VsCode的应用商店中搜索 Codellm,选择`Codellm: Use Ollama and OpenAI to write code`插件并安装。安装完成后，进入该插件的设置页面:

![Codellm setting page](/images/202502/CodellmSettingPage.jpg)

+ **Codellm:Provider**：选择 `ollama`；
+ **Codellm:Ollama:Url**：填写之前部署的 ollama 服务的 NodePort 访问地址；
+ **Codellm:Prompt Prefix:...**：将默认英文的 prompt 修改为中文，用于提示模型生成代码的中文上下文：
![set chinese prompt](/images/202502/CodellmSetPrompt.jpg)

至此，设置完成。使用就很简单了，一种是直接在左侧导航栏选择 Codellm，在对话模式中进行问答，另外一种方式是，在编辑器中选择相关的代码右键，在右键的菜单中会出现 Codellm 的相关功能,点击之后会在对话框中出现选择的代码，并进行代码解析、注释生成、寻找代码bug等动作：

![how to use Codellm](/images/202502/howToUseCodellm.jpg)

## 使用code2prompt整理项目源码并向LLM提问

在[在VisualStudioCode安装使用Codellm](#在VisualStudioCode安装使用Codellm)章节中介绍了使用Codellm的方法，但是我们可以发现，这种工具只能对某一段代码进行提问。当我们需要对整个项目的代码进行提问时，代码分布在不同的文件夹，源码文件中，逐个文件打开并复制代码到LLM的对话框中，显然是一种非常低效的方法。我在 github 中找到这个开源的项目：[code2prompt](https://github.com/mufeedvh/code2prompt)，它提供命令行的方式将一个代码项目的代码整合成一个 prompt 文件，并输出这个 prompt 需要消耗的 token 数量，以帮助我们判断这个 prompt 是否适合提交到对应的 LLM 模型。该软件安装的过程，请参考官网的[Installation](https://github.com/mufeedvh/code2prompt?tab=readme-ov-file#installation)自行安装。

接下来，我演示以下如何使用此命令行工具，就以[code2prompt](https://github.com/mufeedvh/code2prompt)本身为例：

```bash
 lewlh@DESKTOP ~/workspace/code2prompt > tree
.
├── Cargo.lock
├── Cargo.toml
├── LICENSE
├── README.md
├── README_ES.md
├── build.rs
├── docs
│   ├── book.toml
│   └── src
│       ├── SUMMARY.md
│       ├── assets
│       │   └── filter.png
│       │   ├── glob_patterns.md
│       │   └── tokenizers.md
│       ├── how_to
│       │   ├── exclude_files_from_tree.md
│       │   ├── filter_files.md
│       │   ├── install.md
│       │   └── save_generated_prompt.md
│       ├── introduction.md
│       ├── references
│       │   ├── command_line_options.md
│       │   └── default_template.md
│       └── tutorials
│           ├── getting_started.md
│           ├── templates.md
│           ├── use_filter.md
│           ├── using_glob_pattern_tool.md
│           └── using_templates.md
├── pyproject.toml
├── python-sdk
│   ├── README.md
│   ├── __init__.py
│   ├── code2prompt
│   │   ├── __init__.py
│   │   └── code2prompt.py
│   ├── examples
│   │   └── basic_usage.py
│   └── setup.py
├── src
│   ├── clipboard.rs
│   ├── default_template.hbs
│   ├── filter.rs
│   ├── git.rs
│   ├── lib.rs
│   ├── main.rs
│   ├── path.rs
│   ├── python.rs
│   ├── sort.rs
│   ├── template.rs
│   ├── token.rs
│   └── util.rs
├── templates
│   ├── binary-exploitation-ctf-solver.hbs
│   ├── claude-xml.hbs
│   ├── clean-up-code.hbs
│   ├── cryptography-ctf-solver.hbs
│   ├── document-the-code.hbs
│   ├── find-security-vulnerabilities.hbs
│   ├── fix-bugs.hbs
│   ├── improve-performance.hbs
│   ├── refactor.hbs
│   ├── reverse-engineering-ctf-solver.hbs
│   ├── web-ctf-solver.hbs
│   ├── write-git-commit.hbs
│   ├── write-github-pull-request.hbs
│   └── write-github-readme.hbs
└── tests
    ├── clipboard_test.rs
    ├── filter_test.rs
    ├── git_test.rs
    ├── integration_test.rs
    ├── sort_test.rs
    ├── template_test.rs
    └── util_test.rs

13 directories, 65 files
```

+ 由于此项目用 Rust 编写，因此我尝试学习 `src` 文件夹下面的 *.rs 文件；
+ 在此项目下执行 `code2prompt --tokens --output=code2prompt.txt src`
  ```bash
  lewlh@LWHM-DESKTOP  ~/workspace/code2prompt   main  code2prompt --tokens --output=code2prompt.txt src
  ▹▹▹▹▸ Done!
  [i] Token count: 12289, Model info: ChatGPT models, text-embedding-ada-002
  [✓] Copied to clipboard successfully.
  [✓] Prompt written to file: code2prompt.txt
  ```
+ 命令执行完成后，我们可以看到这个 prompt 需要消耗的 token 数量，以及生成了一个`code2prompt.txt`文件,且这个文件的内容已经默认复制到粘贴板中了；
+ 利用`code2prompt.txt`的内容，我们可以直接复制到 LLM 对话框内进行对话了；
+ 由于`code2prompt.txt`是根据LLM的规范进行整理生成的，一般大语言模型能很好地理解代码的整体情况，帮助我们更快地分析定位问题，找到我们想要的答案；

## 总结

本文提供的一个简单但闭环的构建私有LLM代码助手的方案，我认为足以应付90%个人以及小团队的编码开发问答需求，部署以及上手难度都可控。要是你有更好的方案，欢迎留言讨论交流。

## References

+ [Ollama Docker image](https://hub.docker.com/r/ollama/ollama)
+ [page-assist](https://github.com/n4ze3m/page-assist)
+ [Codellm: Use Ollama and OpenAI to write code](https://marketplace.visualstudio.com/items?itemName=ekbanasolutions.codellm)
+ [Helm Chart Of Ollama](https://github.com/lewlh/share/tree/main/helm-chart/ollama)
+ [code2prompt](https://github.com/mufeedvh/code2prompt)