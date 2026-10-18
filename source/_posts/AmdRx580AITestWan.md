---
title: AMD RX580 AI部署记录:ComfyUI+Wan2.1
date: 2025-03-02 23:19:59
tags:
    - RX580
    - zluda
    - comfyui
    - wan2.1
---

![Wan logo](https://raw.githubusercontent.com/Wan-Video/Wan2.1/refs/heads/main/assets/logo.png)

AMD RX580 可以运行 Wan2.1 跑文生视频、图生视频吗？NVIDIA RTX4090 可以在大约4分钟内生成5秒的480p视频,这张矿卡需要跑多久？带着这些问题，我开始了这段探索之旅。

<!-- more -->

**********

ComfyUI 已经支持 Wan2.1 的部署，并提供了教程 [ComfyUI_examples_Wan_2.1_Models](https://comfyanonymous.github.io/ComfyUI_examples/wan/) 。

## 文生视频

按照官方指南，我们需要下载以下模型：

+ 下载[umt5_xxl_fp8_e4m3fn_scaled.safetensors](https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/blob/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors)，并将此文件放置在 `ComfyUI/models/text_encoders/` 目录下；
+ 下载[wan_2.1_vae.safetensors](https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/blob/main/split_files/vae/wan_2.1_vae.safetensors)，并将此文件放置在 `ComfyUI/models/vae/` 目录下；
+ 下载[wan2.1_i2v_480p_14B_bf16.safetensors](https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/blob/main/split_files/diffusion_models/wan2.1_i2v_480p_14B_bf16.safetensors)，并将此文件放置在 `ComfyUI/models/diffusion_models/` 目录下；
+ 下载 Wan2.1 的示例图片以配置 ComfyUI 的 workflow：

![text_to_video_wan.webp](https://comfyanonymous.github.io/ComfyUI_examples/wan/text_to_video_wan.webp)

将下载的**text_to_video_wan.webp**图片拖动到 <http://127.0.0.1:8188/> ComfyUI 页面，程序会自动识别此图片中的 workflow，此时检查一下相关的模型是否是之前下载的模型：

![ComfyUI wan setting](/images/202503/ComfyUIWithWan.jpg)

配置好模型，点击**执行**，程序开始生成视频：

```powershell
got prompt
Using split attention in VAE
Using split attention in VAE
VAE load device: cuda:0, offload device: cpu, dtype: torch.bfloat16
CLIP/text encoder model load device: cuda:0, offload device: cpu, current: cpu, dtype: torch.float16
Requested to load WanTEModel
loaded partially 2519.78203125 2515.4766159057617 0
0 models unloaded.
loaded partially 2515.476616001129 2515.4766159057617 0
model weight dtype torch.float8_e4m3fn, manual cast: torch.bfloat16
model_type FLOW
Requested to load WAN21
0 models unloaded.
loaded partially 64.0 63.99981689453125 0
  0%|                                                                                                   | 0/30 [00:00<?, ?it/s]Compiling in progress. Please wait...
  7%|██████                                                                                    | 2/30 [04:02<56:25, 120.92s/it]Compiling in progress. Please wait...
Compiling in progress. Please wait...
100%|███████████████████████████████████████████████████████████████████████████████████████| 30/30 [1:00:38<00:00, 121.27s/it]
Requested to load WanVAE
0 models unloaded.
loaded partially 64.0 63.99991416931152 0
Compiling in progress. Please wait...
Prompt executed in 5180.79 seconds
```

从日志上看，足足跑了87分钟，才生成了一个 webp 文件，而且视频生成得还有点问题(灬ꈍ ꈍ灬)：

![wan2.1 webp](/images/202503/ComfyUI_wan2.1.webp)

## 图生视频

按照官方指南，我们需要下载以下模型：

+ 下载[wan2.1_i2v_480p_14B_fp8_e4m3fn.safetensors](https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/blob/main/split_files/diffusion_models/wan2.1_i2v_480p_14B_fp8_e4m3fn.safetensors)，并将此文件放置在 `ComfyUI/models/diffusion_models/` 目录下；
+ 下载[clip_vision_h.safetensors](https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/blob/main/split_files/clip_vision/clip_vision_h.safetensors)，并将此文件放置在 `ComfyUI/models/clip_vision/` 目录下；
+ 下载[image_to_video_wan_example.json](https://comfyanonymous.github.io/ComfyUI_examples/wan/image_to_video_wan_example.json)工作流，用于后续步骤；
  + 将此文件拖动到  <http://127.0.0.1:8188/> ComfyUI 页面，程序会自动识别此图片中的 workflow，此时检查一下相关的模型是否是之前下载的模型：
+ 下载[flux_dev_checkpoint_example.png](https://comfyanonymous.github.io/ComfyUI_examples/flux/flux_dev_checkpoint_example.png)图片，用于图生视频，力图还原demo的视频效果；
  + ![flux_dev_checkpoint_example](https://comfyanonymous.github.io/ComfyUI_examples/flux/flux_dev_checkpoint_example.png)
  + 点击 ComfyUI 该工作流的加载图片，将此图片添加到工作流中；
+ ![ComfyUI wan setting2](/images/202503/ComfyUISetting.jpg)
+ 配置好模型，点击**执行**，程序开始生成视频：

```powershell
   ComfyUI-Zluda  master ≡  ?1   3.10.16   59.198s⠀   .\comfyui.bat --use-split-cross-attention
*** Checking and updating to new version if possible
Already up to date.

[START] Security scan
[DONE] Security scan
## ComfyUI-Manager: installing dependencies done.
** ComfyUI startup time: 2025-03-03 22:35:41.078
** Platform: Windows
** Python version: 3.10.16 | packaged by Anaconda, Inc. | (main, Dec 11 2024, 16:19:12) [MSC v.1929 64 bit (AMD64)]
** Python executable: C:\Users\lewlh\workspaceWin\ComfyUI-Zluda\venv\Scripts\python.exe
** ComfyUI Path: C:\Users\lewlh\workspaceWin\ComfyUI-Zluda
** ComfyUI Base Folder Path: C:\Users\lewlh\workspaceWin\ComfyUI-Zluda
** User directory: C:\Users\lewlh\workspaceWin\ComfyUI-Zluda\user
** ComfyUI-Manager config path: C:\Users\lewlh\workspaceWin\ComfyUI-Zluda\user\default\ComfyUI-Manager\config.ini
** Log path: C:\Users\lewlh\workspaceWin\ComfyUI-Zluda\user\comfyui.log

Prestartup times for custom nodes:
  10.5 seconds: C:\Users\lewlh\workspaceWin\ComfyUI-Zluda\custom_nodes\ComfyUI-Manager

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
[Prompt Server] web root: C:\Users\lewlh\workspaceWin\ComfyUI-Zluda\venv\lib\site-packages\comfyui_frontend_package\static
### Loading: ComfyUI-Manager (V3.25.1)
[ComfyUI-Manager] network_mode: public
### ComfyUI Revision: 3697 [f12bcde3] | Released on '2025-03-03'

Import times for custom nodes:
   0.0 seconds: C:\Users\lewlh\workspaceWin\ComfyUI-Zluda\custom_nodes\ComfyUI-deepcache
   0.0 seconds: C:\Users\lewlh\workspaceWin\ComfyUI-Zluda\custom_nodes\websocket_image_save.py
   2.6 seconds: C:\Users\lewlh\workspaceWin\ComfyUI-Zluda\custom_nodes\ComfyUI-Manager

Starting server

To see the GUI go to: http://127.0.0.1:8188
[ComfyUI-Manager] default cache updated: https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/model-list.json
[ComfyUI-Manager] default cache updated: https://raw.githubusercontent.com/ltdrdata/ComfyUI-Manager/main/alter-list.json
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
got prompt
Using split attention in VAE
Using split attention in VAE
VAE load device: cuda:0, offload device: cpu, dtype: torch.bfloat16
Requested to load CLIPVisionModelProjection
loaded completely 6323.2 1208.09814453125 True
CLIP/text encoder model load device: cuda:0, offload device: cpu, current: cpu, dtype: torch.float16
Requested to load WanTEModel
loaded partially 5629.075 5619.477012634277 0
0 models unloaded.
loaded partially 5619.477012729645 5619.477012634277 0
Requested to load WanVAE
loaded partially 64.0 63.99991416931152 0
model weight dtype torch.float8_e4m3fn, manual cast: torch.bfloat16
model_type FLOW
Requested to load WAN21
0 models unloaded.
loaded partially 64.0 63.60723876953125 0
 75%|███████████████████████████████████████████████████████████████                     | 15/20 [5:37:34<1:53:39, 1363.94s/ 
 80%|███████████████████████████████████████████████████████████████████▏                | 16/20 [6:00:31<1:31:12, 1368.07s/ 
 85%|███████████████████████████████████████████████████████████████████████▍            | 17/20 [6:23:14<1:08:19, 1366.55s/ 
 90%|█████████████████████████████████████████████████████████████████████████████▍        | 18/20 [6:45:55<45:29, 1364.77s/ 
 95%|█████████████████████████████████████████████████████████████████████████████████▋    | 19/20 [7:08:36<22:43, 1363.78s/
 100%|██████████████████████████████████████████████████████████████████████████████████████| 20/20 [7:31:18<00:00, 1363.08s/
 100%|██████████████████████████████████████████████████████████████████████████████████████| 20/20 [7:31:18<00:00, 1353.91s/it]
Requested to load WanVAE
0 models unloaded.
loaded partially 64.0 63.99991416931152 0
Prompt executed in 28429.51 seconds
```

从日志上看，足足跑了快8个小时，生成了一个 webp 文件，而且视频生成得还是有问题(灬ꈍ ꈍ灬)：

![wan2.1 webp](/images/202503/ComfyUI_wan2.1_image_to_video.webp)

可能我配置的模型不匹配，导致最后的结果很差，不可用的状态。另外使用 AMD RX580 做视频生成，时间成本太高，我只能劝退大家，花钱买更好的显卡吧！

## References

+ [AMD RX580 AI部署记录:ComfyUI+Flux](https://lewlh.github.io/2025/02/26/AmdRx580AITestComfyuiZluda/)
+ [Wan2.1](https://github.com/Wan-Video/Wan2.1)
+ [ComfyUI_examples_Wan_2.1_Models](https://comfyanonymous.github.io/ComfyUI_examples/wan/)