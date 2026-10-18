---
title: AMD RX580 AI部署记录
date: 2025-01-15 17:13:12
tags:
    - RX580
    - AMD
    - Ollama
    - ComfyUI
    - FaceFusion
    - DrawThings
---

博主 2024 年心血来潮，花了一些钱组装了一台 x99 洋垃圾主机，因囊周羞涩只买了一张 AMD RX580 矿卡，但是这张卡其实也能跑一下 AI 大模型，也是老当益壮了。我的计划是尝试一下的 AI 应用：

+ [Ollama](https://github.com/ollama/ollama)
+ [ComfyUI](https://github.com/comfyanonymous/ComfyUI)
+ [FaceFusion](https://github.com/facefusion/facefusion)
+ [DrawThings](https://drawthings.ai/)

本文将记录我的尝试过程,分享给有需要的朋友。

![GPU-Z参数](/images/202501/GPU-Z.gif)

<!-- more -->

**********

## 情况说明

博主的主机配置，详细说明可阅读此博文[《x99 平台组装记录》](https://lewlh.github.io/2024/10/16/x99E5PC/)。由于 AMD RX580 是2017年的老显卡，很多 AI 工具链都已经不支持了，如 AMD 的 ROCm，想要尝试部署2024/2025年出的模型，需要花一些时间精力找适配的办法，并不那么简单。从我搜集的资料看，存在以下问题：

+ AMD 最新版本的 ROCm 工具已经不支持 Polaris 架构系列的显卡芯片;
+ 支持 Polaris 架构的 ROCm，目前只支持在 linux 系统安装，如 Ubuntu22.04；
+ Windows10/11 以及 WSL/WSL2 都不支持 Polaris 架构的显卡；

然而比较幸运的是，AMD RX580 显卡支持黑苹果，而且在黑苹果中这款显卡是支持 Apple Metal2，基于这个接口可以支持很多模型的部署。博主花了很多时间，在这台洋垃圾上通过 OpenCore 安装了黑苹果（安装的情况可查看此 github 项目：[HUANANZHI-X99-TF-OC-EFI](https://github.com/lewlh/HUANANZHI-X99TF-OC-EFI),因此我的部署实践基本都基于 MacOS Ventura 系统上进行，如果有余力，会尝试在 win11 部署测试。另外，博主手里也还有 Macbook Pro M1 以及 Macbook Pro 2017 15.4Inch 高配，有机会也会跑一下 benchmark 简单对比一下他们之间的 AI 性能差异。

## 文章列表

该主题内容太多，作者分成多篇文章完成，请点击链接阅读：

+ [《AMD RX580 AI部署记录:ComfyUI+Wan2.1》](https://lewlh.github.io/2025/03/02/AmdRx580AITestWan/)
+ [《AMD RX580 AI部署记录:ComfyUI+Flux》](https://lewlh.github.io/2025/02/26/AmdRx580AITestComfyuiZluda/)
+ [《AMD RX580 AI部署记录:Ollama》](https://lewlh.github.io/2025/02/03/AmdRx580AITestOllama/)

## References

+ [ROCm with gfx803](https://github.com/xuhuisheng/rocm-gfx803)
+ [家庭数据中心系列 Mac上免费的入门级本地AI图像生成工具(下篇)：Draw Things安装及使用教程 - 无敌的个人博客](https://blog.tangwudi.com/en/technology/homedatacenter12805)
+ [MetalDiffusion](https://github.com/soten355/MetalDiffusion)
+ [MetalDiffusion - Stable Diffusion for Intel MacOS and Silicon MacOS](https://www.reddit.com/r/StableDiffusion/comments/11sceqp/metaldiffusion_stable_diffusion_for_intel_macos/)
+ [Sharing the experience of using DirectML for the new users.](https://github.com/lshqqytiger/stable-diffusion-webui-amdgpu/discussions/84)
+ [Diffusion Bee - Stable Diffusion GUI App for MacOS](https://github.com/divamgupta/diffusionbee-stable-diffusion-ui)