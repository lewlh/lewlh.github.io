---
title: AMD RX580 AI部署记录:ComfyUI+Flux
date: 2025-02-26 18:06:49
tags:
    - RX580
    - zluda
    - comfyui
    - Flux
---

![FLUX生成的图片](/images/202502/FLUX生成的图片.png)

FLUX.1 是由 Black Forest Labs 开发的文本到图像生成模型,而它提供的 FLUX.1 [schnell]可以在比较低端的拥有 8GB 显存的 GPU 上运行。我调查了一下互联网上各路大神的部署方案，发现有一个 [ComfyUI-Zluda](https://github.com/patientx/ComfyUI-Zluda) 项目，支持使用 AMD RX580 显卡做部署推理。本文是此项目部署的实践，并最终成功运行并推理生成图片，特此将部署过程分享给大家。

<!-- more -->

**********

## ComfyUI-Zluda的安装部署

按照[ComfyUI-Zluda](https://github.com/patientx/ComfyUI-Zluda)提供的安装指南安装后ComfyUI可以成功运行，但是无法成功使用 FLUX.1[schnell] 推理出图片，生成都都是纯灰色的图。经过我的探索最终修复了这个问题，下面我把我这边完整的安装步骤提供给大家，我电脑的硬件配置请查看我之前的博客文章[X99 平台组装记录](https://lewlh.github.io/2024/10/16/x99E5PC/#%E6%9C%80%E5%90%8E%E7%9A%84%E4%B8%BB%E6%9C%BA%E9%85%8D%E7%BD%AE),使用的系统是 Windows11LTSC。

+ 从[github](https://github.com/patientx/ComfyUI-Zluda)拉取该项目到本地；
+ 项目推荐使用 python3.10，我使用 miniconda 单独创建名为 comfyui 的 python3.10 的环境；
+ 安装 [vc_redist.x64.exe ](https://aka.ms/vs/17/release/vc_redist.x64.exe)
+ 安装 [HIP SDK 5.7.1](https://www.amd.com/en/developer/resources/rocm-hub/eula/licenses.html?filename=AMD-Software-PRO-Edition-23.Q4-Win10-Win11-For-HIP.exe)
  + HIP SDK 5.7.1 官方应该已经是不支持 AMD RX580 这款旧型号显卡，需要安装额外的依赖才能完整支持，我通过安装[ROCmLibs-for-gfx1103-AMD780M-APU](https://github.com/likelovewant/ROCmLibs-for-gfx1103-AMD780M-APU)这个项目[v0.5.7版本](https://github.com/likelovewant/ROCmLibs-for-gfx1103-AMD780M-APU/releases/tag/v0.5.7)相关库文件[rocblas.for.gfx803.override.with.vega10.7z](https://github.com/likelovewant/ROCmLibs-for-gfx1103-AMD780M-APU/releases/download/v0.5.7/rocblas.for.gfx803.override.with.vega10.7z),替换HIP SDK 5.7.1的部分文件，实现功能支持；
  + 解压 `rocblas.for.gfx803.override.with.vega10.7z` 压缩文件后，我们能看到以下文件:

    ```bash
    .
    ├── library
    │   ├── Kernels.so-000-gfx803.hsaco
    │   ├── TensileLibrary_Type_4xi8I_HPA_Contraction_l_Ailk_Bjlk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_4xi8I_HPA_Contraction_l_Ailk_Bjlk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_4xi8I_HPA_Contraction_l_Ailk_Bljk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_4xi8I_HPA_Contraction_l_Ailk_Bljk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_4xi8I_HPA_Contraction_l_Alik_Bjlk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_4xi8I_HPA_Contraction_l_Alik_Bjlk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_4xi8I_HPA_Contraction_l_Alik_Bljk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_4xi8I_HPA_Contraction_l_Alik_Bljk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_BB_HPA_Contraction_l_Ailk_Bjlk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_BB_HPA_Contraction_l_Ailk_Bjlk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_BB_HPA_Contraction_l_Ailk_Bljk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_BB_HPA_Contraction_l_Ailk_Bljk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_BB_HPA_Contraction_l_Alik_Bjlk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_BB_HPA_Contraction_l_Alik_Bjlk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_BB_HPA_Contraction_l_Alik_Bljk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_BB_HPA_Contraction_l_Alik_Bljk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_BS_HPA_Contraction_l_Ailk_Bjlk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_BS_HPA_Contraction_l_Ailk_Bjlk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_BS_HPA_Contraction_l_Ailk_Bljk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_BS_HPA_Contraction_l_Ailk_Bljk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_BS_HPA_Contraction_l_Alik_Bjlk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_BS_HPA_Contraction_l_Alik_Bjlk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_BS_HPA_Contraction_l_Alik_Bljk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_BS_HPA_Contraction_l_Alik_Bljk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_CC_Contraction_l_Ailk_BjlkC_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_CC_Contraction_l_Ailk_BjlkC_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_CC_Contraction_l_Ailk_Bjlk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_CC_Contraction_l_Ailk_Bjlk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_CC_Contraction_l_Ailk_Bjlk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_CC_Contraction_l_Ailk_Bjlk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_CC_Contraction_l_Ailk_Bljk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_CC_Contraction_l_Ailk_Bljk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_CC_Contraction_l_Ailk_Bljk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_CC_Contraction_l_Ailk_Bljk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_CC_Contraction_l_AlikC_BjlkC_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_CC_Contraction_l_AlikC_BjlkC_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_CC_Contraction_l_AlikC_Bjlk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_CC_Contraction_l_AlikC_Bjlk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_CC_Contraction_l_AlikC_Bljk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_CC_Contraction_l_AlikC_Bljk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_CC_Contraction_l_Alik_BjlkC_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_CC_Contraction_l_Alik_BjlkC_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_CC_Contraction_l_Alik_Bjlk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_CC_Contraction_l_Alik_Bjlk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_CC_Contraction_l_Alik_Bjlk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_CC_Contraction_l_Alik_Bjlk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_CC_Contraction_l_Alik_Bljk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_CC_Contraction_l_Alik_Bljk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_CC_Contraction_l_Alik_Bljk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_CC_Contraction_l_Alik_Bljk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_DD_Contraction_l_Ailk_Bjlk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_DD_Contraction_l_Ailk_Bjlk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_DD_Contraction_l_Ailk_Bjlk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_DD_Contraction_l_Ailk_Bjlk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_DD_Contraction_l_Ailk_Bljk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_DD_Contraction_l_Ailk_Bljk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_DD_Contraction_l_Ailk_Bljk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_DD_Contraction_l_Ailk_Bljk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_DD_Contraction_l_Alik_Bjlk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_DD_Contraction_l_Alik_Bjlk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_DD_Contraction_l_Alik_Bjlk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_DD_Contraction_l_Alik_Bjlk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_DD_Contraction_l_Alik_Bljk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_DD_Contraction_l_Alik_Bljk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_DD_Contraction_l_Alik_Bljk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_DD_Contraction_l_Alik_Bljk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_HH_Contraction_l_Ailk_Bjlk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_HH_Contraction_l_Ailk_Bjlk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_HH_Contraction_l_Ailk_Bjlk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_HH_Contraction_l_Ailk_Bjlk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_HH_Contraction_l_Ailk_Bljk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_HH_Contraction_l_Ailk_Bljk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_HH_Contraction_l_Ailk_Bljk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_HH_Contraction_l_Ailk_Bljk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_HH_Contraction_l_Alik_Bjlk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_HH_Contraction_l_Alik_Bjlk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_HH_Contraction_l_Alik_Bjlk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_HH_Contraction_l_Alik_Bjlk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_HH_Contraction_l_Alik_Bljk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_HH_Contraction_l_Alik_Bljk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_HH_Contraction_l_Alik_Bljk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_HH_Contraction_l_Alik_Bljk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_HH_HPA_Contraction_l_Ailk_Bjlk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_HH_HPA_Contraction_l_Ailk_Bjlk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_HH_HPA_Contraction_l_Ailk_Bjlk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_HH_HPA_Contraction_l_Ailk_Bjlk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_HH_HPA_Contraction_l_Ailk_Bljk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_HH_HPA_Contraction_l_Ailk_Bljk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_HH_HPA_Contraction_l_Ailk_Bljk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_HH_HPA_Contraction_l_Ailk_Bljk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_HH_HPA_Contraction_l_Alik_Bjlk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_HH_HPA_Contraction_l_Alik_Bjlk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_HH_HPA_Contraction_l_Alik_Bjlk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_HH_HPA_Contraction_l_Alik_Bjlk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_HH_HPA_Contraction_l_Alik_Bljk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_HH_HPA_Contraction_l_Alik_Bljk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_HH_HPA_Contraction_l_Alik_Bljk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_HH_HPA_Contraction_l_Alik_Bljk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_HS_HPA_Contraction_l_Ailk_Bjlk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_HS_HPA_Contraction_l_Ailk_Bjlk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_HS_HPA_Contraction_l_Ailk_Bjlk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_HS_HPA_Contraction_l_Ailk_Bjlk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_HS_HPA_Contraction_l_Ailk_Bljk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_HS_HPA_Contraction_l_Ailk_Bljk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_HS_HPA_Contraction_l_Ailk_Bljk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_HS_HPA_Contraction_l_Ailk_Bljk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_HS_HPA_Contraction_l_Alik_Bjlk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_HS_HPA_Contraction_l_Alik_Bjlk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_HS_HPA_Contraction_l_Alik_Bjlk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_HS_HPA_Contraction_l_Alik_Bjlk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_HS_HPA_Contraction_l_Alik_Bljk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_HS_HPA_Contraction_l_Alik_Bljk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_HS_HPA_Contraction_l_Alik_Bljk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_HS_HPA_Contraction_l_Alik_Bljk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_I8I_HPA_Contraction_l_Ailk_Bjlk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_I8I_HPA_Contraction_l_Ailk_Bjlk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_I8I_HPA_Contraction_l_Ailk_Bljk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_I8I_HPA_Contraction_l_Ailk_Bljk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_I8I_HPA_Contraction_l_Alik_Bjlk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_I8I_HPA_Contraction_l_Alik_Bjlk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_I8I_HPA_Contraction_l_Alik_Bljk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_I8I_HPA_Contraction_l_Alik_Bljk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_SS_Contraction_l_Ailk_Bjlk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_SS_Contraction_l_Ailk_Bjlk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_SS_Contraction_l_Ailk_Bjlk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_SS_Contraction_l_Ailk_Bjlk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_SS_Contraction_l_Ailk_Bljk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_SS_Contraction_l_Ailk_Bljk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_SS_Contraction_l_Ailk_Bljk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_SS_Contraction_l_Ailk_Bljk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_SS_Contraction_l_Alik_Bjlk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_SS_Contraction_l_Alik_Bjlk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_SS_Contraction_l_Alik_Bjlk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_SS_Contraction_l_Alik_Bjlk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_SS_Contraction_l_Alik_Bljk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_SS_Contraction_l_Alik_Bljk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_SS_Contraction_l_Alik_Bljk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_SS_Contraction_l_Alik_Bljk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_Ailk_BjlkC_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_Ailk_BjlkC_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_Ailk_Bjlk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_Ailk_Bjlk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_Ailk_Bjlk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_Ailk_Bjlk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_Ailk_Bljk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_Ailk_Bljk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_Ailk_Bljk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_Ailk_Bljk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_AlikC_BjlkC_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_AlikC_BjlkC_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_AlikC_Bjlk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_AlikC_Bjlk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_AlikC_Bljk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_AlikC_Bljk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_Alik_BjlkC_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_Alik_BjlkC_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_Alik_Bjlk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_Alik_Bjlk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_Alik_Bjlk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_Alik_Bjlk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_Alik_Bljk_Cijk_Dijk_fallback.dat
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_Alik_Bljk_Cijk_Dijk_fallback_gfx803.hsaco
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_Alik_Bljk_Cijk_Dijk_gfx900.co
    │   ├── TensileLibrary_Type_ZZ_Contraction_l_Alik_Bljk_Cijk_Dijk_gfx900.dat
    │   ├── TensileLibrary_lazy_gfx803.dat
    │   ├── TensileLibrary_lazy_gfx900.dat
    │   └── TensileManifest.txt
    └── rocblas.dll

    1 directory, 169 files
    ```

    + 将 `rocblas.dll` 文件，复制替换 `ROCm` 安装目录下的 `./5.7/bin/rocblas.dll` 文件;
    + 将 `library` 文件夹，复制替换 `ROCm` 安装目录下 `./5.7/bin/rocblas/library ` 文件夹；
+ 配置环境变量，修改用户变量**PATH**添加ROCm的路径：`C:\Program Files\AMD\ROCm\5.7\bin`；
+ 配置环境变量，添加系统变量**HIP_PATH**添加ROCm的路径：`C:\Program Files\AMD\ROCm\5.7\`；
+ 打开PowerShell终端，进入 ComfyUI-Zluda 项目目录，执行`.\install.bat` 安装依赖；
+ 接着请执行 `.\fixforrx580.bat` 执行针对 AMD RX580 显卡的依赖安装；
+ 完成以上步骤，在此目录执行 `.\comfyui.bat --use-split-cross-attention` 启动程序，可以看到以下日志信息：

    ```PowerShell
    *** Checking and updating to new version if possible
    remote: Enumerating objects: 13, done.
    remote: Counting objects: 100% (13/13), done.
    remote: Compressing objects: 100% (8/8), done.
    remote: Total 13 (delta 7), reused 7 (delta 5), pack-reused 0 (from 0)
    Unpacking objects: 100% (13/13), 5.71 KiB | 77.00 KiB/s, done.
    From https://github.com/patientx/ComfyUI-Zluda
    0c4bebf5..7763bf82  master     -> origin/master
    Updating 0c4bebf5..7763bf82
    Fast-forward
    comfy/samplers.py         | 3 +++
    comfy_extras/nodes_wan.py | 6 +++---
    2 files changed, 6 insertions(+), 3 deletions(-)

    [START] Security scan
    [DONE] Security scan
    ## ComfyUI-Manager: installing dependencies done.
    ** ComfyUI startup time: 2025-03-02 22:22:46.798
    ** Platform: Windows
    ** Python version: 3.10.16 | packaged by Anaconda, Inc. | (main, Dec 11 2024, 16:19:12) [MSC v.1929 64 bit (AMD64)]
    ** Python executable: C:\Users\lewlh\workspaceWin\ComfyUI-Zluda\venv\Scripts\python.exe
    ** ComfyUI Path: C:\Users\lewlh\workspaceWin\ComfyUI-Zluda
    ** ComfyUI Base Folder Path: C:\Users\lewlh\workspaceWin\ComfyUI-Zluda
    ** User directory: C:\Users\lewlh\workspaceWin\ComfyUI-Zluda\user
    ** ComfyUI-Manager config path: C:\Users\lewlh\workspaceWin\ComfyUI-Zluda\user\default\ComfyUI-Manager\config.ini
    ** Log path: C:\Users\lewlh\workspaceWin\ComfyUI-Zluda\user\comfyui.log

    Prestartup times for custom nodes:
    14.4 seconds: C:\Users\lewlh\workspaceWin\ComfyUI-Zluda\custom_nodes\ComfyUI-Manager

    Warning, you are using an old pytorch version and some ckpt/pt files might be loaded unsafely. Upgrading to 2.4 or above is recommended.

    ***----------------------ZLUDA-----------------------------***
    ::  ZLUDA detected, disabling non-supported functions.
    ::  CuDNN, flash_sdp, mem_efficient_sdp disabled).
    ***--------------------------------------------------------***
    ::  Device :  Radeon RX 580 Series [ZLUDA]

    Total VRAM 8192 MB, total RAM 98210 MB
    pytorch version: 2.2.1+cu118
    Set vram state to: NORMAL_VRAM
    Device: cuda:0 Radeon RX 580 Series [ZLUDA] : native
    Using sub quadratic optimization for attention, if you have memory or speed issues try using: --use-split-cross-attention
    ComfyUI version: 0.3.18
    [Prompt Server] web root: C:\Users\lewlh\workspaceWin\ComfyUI-Zluda\web
    ### Loading: ComfyUI-Manager (V3.25.1)
    [ComfyUI-Manager] network_mode: public
    ### ComfyUI Revision: 3687 [7763bf82] | Released on '2025-03-02'

    Import times for custom nodes:
    0.0 seconds: C:\Users\lewlh\workspaceWin\ComfyUI-Zluda\custom_nodes\websocket_image_save.py
    0.0 seconds: C:\Users\lewlh\workspaceWin\ComfyUI-Zluda\custom_nodes\ComfyUI-deepcache
    2.8 seconds: C:\Users\lewlh\workspaceWin\ComfyUI-Zluda\custom_nodes\ComfyUI-Manager

    Starting server

    To see the GUI go to: http://127.0.0.1:8188
    [ComfyUI-Manager] default cache updated: https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/alter-list.json
    [ComfyUI-Manager] default cache updated: https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/model-list.json
    [ComfyUI-Manager] default cache updated: https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/github-stats.json
    [ComfyUI-Manager] default cache updated: https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/extension-node-map.json
    [ComfyUI-Manager] default cache updated: https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/custom-node-list.json
    FETCH ComfyRegistry Data: 5/36
    FETCH ComfyRegistry Data: 10/36
    FETCH ComfyRegistry Data: 15/36
    FETCH ComfyRegistry Data: 20/36
    FETCH ComfyRegistry Data: 25/36
    FETCH ComfyRegistry Data: 30/36
    FETCH ComfyRegistry Data: 35/36
    FETCH ComfyRegistry Data [DONE]
    [ComfyUI-Manager] default cache updated: https://api.comfy.org/nodes
    nightly_channel: https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/remote
    FETCH DATA from: https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/custom-node-list.json [DONE]
    [ComfyUI-Manager] All startup tasks have been completed.
    ```

+ 程序会自动打开浏览器访问 <http://127.0.0.1:8188/> 进入 ComfyUI 页面，点击左下角齿轮状设置按钮，最新版本的程序可以在设置页面设置系统语言为中文了。

## 部署FLUX.1 [schnell]

我是通过学习零度解说的博文，第一次学习如何部署使用 ComfyUI 的，相关链接请查看[References](#References)。本章节我提炼具体的步骤，以帮助你快速完成第一个可运行的 Pipeline：

### 下载依赖

下载以下模型文件，并按照要求放在指定的目录下：

+ 下载 [flux1-schnell.safetensors](https://huggingface.co/black-forest-labs/FLUX.1-schnell/blob/main/flux1-schnell.safetensors),并将此文件放置在 `ComfyUI/models/unet/` 目录下;
+ 下载 [ae.safetensors](https://huggingface.co/black-forest-labs/FLUX.1-schnell/blob/main/ae.safetensors),并将此文件放置在 `ComfyUI/models/vae/` 目录下;
+ 下载 [clip_l.safetensors](https://huggingface.co/comfyanonymous/flux_text_encoders/blob/main/clip_l.safetensors),并将此文件放置在 `ComfyUI/models/clip/` 目录下;
+ 下载 [t5xxl_fp8_e4m3fn.safetensors](https://huggingface.co/comfyanonymous/flux_text_encoders/blob/main/t5xxl_fp8_e4m3fn.safetensors),并将此文件放置在 `ComfyUI/models/clip/` 目录下;
+ 下载 [Flux Schnell](https://comfyanonymous.github.io/ComfyUI_examples/flux/#flux-schnell)的示例图片以配置 ComfyUI 的 workflow：

![flux_schnell_example.png](https://comfyanonymous.github.io/ComfyUI_examples/flux/flux_schnell_example.png)

### 在ComfyUI中配置使用Flux

将下载的**flux_schnell_example.png**图片拖动到 <http://127.0.0.1:8188/> ComfyUI 页面，程序会自动识别此图片中的 workflow，此时检查一下相关的模型是否是之前下载的模型：

+ UNet加载器需要设置 UNet 为 `flux1-schnell.safetensors`，数据类型修改为 `fp8_e4m3fn`;
+ 双CLIP加载器CLIP名称1设置为 `t5xxl_fp8_e4m3fn.safetensors`,CLIP名称2设置为 `clip_l.safetensors`;
+ 加载VAE设置VAE为 `ae.safetensors`;
+ 设置提示词，并降低默认分辨率，此处我设置为 456*800，整体配置如下图所示：

![ComfyUI's setting](/images/202502/ComfyUISetting.jpg)

+ 最终运行 182 秒后生成了此图像：

![a very beautiful girl in the bus window, photorealism, perspective，9:16.](/images/202502/ComfyUI_A_beautiful_girl.png)

需要注意的是，这套配置我在使用的过程中会出现程序异常退出的情况，整体而言还是不大稳定，玩一玩可以，当作生产力工具就不大行了！

## References

+ [ComfyUI-Zluda](https://github.com/patientx/ComfyUI-Zluda)
+ [lshqqytiger/ZLUDA](https://github.com/lshqqytiger/ZLUDA)
+ [AMD HIP SDK for Windows](https://www.amd.com/en/developer/resources/rocm-hub/hip-sdk.html)
+ [ROCmLibs-for-gfx1103-AMD780M-APU](https://github.com/likelovewant/ROCmLibs-for-gfx1103-AMD780M-APU)
+ [Flux.1 最强文生图神器！轻松秒出真实质感 “大片”，附最新 ComfyUI 本地部署教程！！ | 零度解说](https://youtu.be/HrnRCwoSSFk?si=fJ4GvyouXZlveCjK)
+ [Flux.1 本地部署！媲美Midjourney的顶级AI绘图模型 ，免费开源，ComfyUI 一键安装，效果惊人！ | 零度解说](https://youtu.be/87TwZ05SSGc?si=DuJlhFphbI5cRpSu)
+ [本地部署 Flux.1 最强文生图大模型！Comfyui 一键安装，简单又方便](https://www.freedidi.com/13266.html)
+ [Flux.1 生成美图、美女的提示词！需要的收藏](https://www.freedidi.com/13328.html)