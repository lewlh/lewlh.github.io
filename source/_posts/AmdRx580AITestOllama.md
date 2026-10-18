---
title: AMD RX580 AI部署记录:Ollama
date: 2025-02-03 18:00:00
tags:
    - RX580
    - AMD
    - Ollama
---

![Ollama](/images/202502/ollama.png)

DeepseekR1 出圈，引起了我非常大的兴趣并想尝试用一下。首先想到的是 Ollama 进行部署，一开始我以为 Ollama 在 MacOS 下面应该是支持 AMD RX580 的显卡进行部署的，结果部署完发现并不能使用，在网上查了一圈，基本的结论是 Ollama 只支持 Metal3 的接口，Metal2 并不支持。所以除非我想办法在这张显卡上安装 MacOS15/Sequoia 及以上版本的系统，不然只能用 CPU 对大语言模型进行推理了。不过我也有新的发现[AMD显卡全系列解锁Ollama支持，llama3运行更优雅！](https://www.bilibili.com/opus/923618797070319625?jump_opus=1)，最近有大神魔改了 ROCm 的驱动，并成功在 windows 下面安装 ollama 并成功调用 AMD RX580 进行推理，真是枯木逢春啊！后面我也做了尝试，果然能用，不过速度相较于纯 E5-2666v3 推理，没有快很多。下面我介绍一下部署的过程。

<!-- more -->

**********

## 在Win11部署Ollama并调用RX580-8G显卡进行大语言模型推理

在 GitHub 上有一个 [ollama-for-amd](https://github.com/likelovewant/ollama-for-amd?tab=readme-ov-file) 项目，专门用来解决使用AMD显卡进行大语言模型推理的问题。综合该项目的描述，我按照以下步骤进行安装,安装的 ollama-for-amd 版本是 [v0.5.4](https://github.com/likelovewant/ollama-for-amd/releases/tag/v0.5.4):

+ 安装 AMD HIP SDK for Windows，Windows 10 & 11 -> ROCm 5.7.1，下载链接[AMD-Software-PRO-Edition-23.Q4-Win10-Win11-For-HIP.exe](https://www.amd.com/en/developer/resources/rocm-hub/eula/licenses.html?filename=AMD-Software-PRO-Edition-23.Q4-Win10-Win11-For-HIP.exe)
+ 安装 [v0.5.4](https://github.com/likelovewant/ollama-for-amd/releases/tag/v0.5.4) 的 [OllamaSetup.exe](https://github.com/likelovewant/ollama-for-amd/releases/download/v0.5.4/OllamaSetup.exe);
  + 此安装包是全量安装包，安装后可以在windows上设置自动启动，在系统右下角有小图标，方便管理以及查看日志。
+ 通过 OllamaSetup.exe 完成 Ollama 安装后，需要替换部分二进制文件；在 [ROCmLibs-for-gfx1103-AMD780M-APU](https://github.com/likelovewant/ROCmLibs-for-gfx1103-AMD780M-APU) 项目中，下载需要替换的 ROCm 的相关二进制文件。我下载的是 [rocblas 3.1.0 for ROCm 5.7.0 ( for Windows)](https://github.com/likelovewant/ROCmLibs-for-gfx1103-AMD780M-APU/releases/tag/v0.5.7) 版本的 [rocblas.for.gfx803.override.with.vega10.7z](https://github.com/likelovewant/ROCmLibs-for-gfx1103-AMD780M-APU/releases/download/v0.5.7/rocblas.for.gfx803.override.with.vega10.7z);
  + 找到 Ollama 的安装目录，通常地址为 `C:\Users\${USER}\AppData\Local\Programs\Ollama`,注意`${USER}`是你实际的用户名；
  + 解压**rocblas.for.gfx803.override.with.vega10.7z**压缩文件，使用里面的 `rocblas.dll` 替换`C:\Users\${USER}\AppData\Local\Programs\Ollama\lib\ollama\rocblas.dll`文件；
  + 解压**rocblas.for.gfx803.override.with.vega10.7z**压缩文件，使用里面的 `library` 文件夹，替换`C:\Users\${USER}\AppData\Local\Programs\Ollama\lib\ollama\rocblas\library`文件夹；
+ 至此，安装和修改过程结束，下面验证是否启用了GPU进行大语言模型的部署.打开 PowerShell 终端，执行 `ollama serve` 命令，如果能看到 `source=types.go:131 msg="inference compute" id=0 library=rocm variant="" compute=gfx803 driver=5.7 name="Radeon RX 580 Series" total="8.0 GiB" available="7.9 GiB"` 的日志信息，基本可以确定 Ollama 可以使用 AMD 的 GPU 进行推理了，我这边的日志如下：

```powershell
PS C:\Users\test> ollama serve
2025/02/03 21:59:23 routes.go:1259: INFO server config env="map[CUDA_VISIBLE_DEVICES: GPU_DEVICE_ORDINAL: HIP_VISIBLE_DEVICES: HSA_OVERRIDE_GFX_VERSION: HTTPS_PROXY: HTTP_PROXY: NO_PROXY: OLLAMA_DEBUG:false OLLAMA_FLASH_ATTENTION:false OLLAMA_GPU_OVERHEAD:0 OLLAMA_HOST:http://:11434 OLLAMA_INTEL_GPU:false OLLAMA_KEEP_ALIVE:5m0s OLLAMA_KV_CACHE_TYPE: OLLAMA_LLM_LIBRARY: OLLAMA_LOAD_TIMEOUT:5m0s OLLAMA_MAX_LOADED_MODELS:0 OLLAMA_MAX_QUEUE:512 OLLAMA_MODELS:C:\\Users\\lewlh\\.ollama\\models OLLAMA_MULTIUSER_CACHE:false OLLAMA_NOHISTORY:false OLLAMA_NOPRUNE:false OLLAMA_NUM_PARALLEL:0 OLLAMA_ORIGINS:[* http://localhost https://localhost http://localhost:* https://localhost:* http://127.0.0.1 https://127.0.0.1 http://127.0.0.1:* https://127.0.0.1:* http://0.0.0.0 https://0.0.0.0 http://0.0.0.0:* https://0.0.0.0:* app://* file://* tauri://* vscode-webview://*] OLLAMA_SCHED_SPREAD:false ROCR_VISIBLE_DEVICES:]"
time=2025-02-03T21:59:23.969+08:00 level=INFO source=images.go:757 msg="total blobs: 13"
time=2025-02-03T21:59:23.973+08:00 level=INFO source=images.go:764 msg="total unused blobs removed: 0"
time=2025-02-03T21:59:23.975+08:00 level=INFO source=routes.go:1310 msg="Listening on [::]:11434 (version 0.5.4-1-g5c9deab)"
time=2025-02-03T21:59:23.977+08:00 level=INFO source=routes.go:1339 msg="Dynamic LLM libraries" runners="[cpu_avx cpu_avx2 rocm_avx cpu]"
time=2025-02-03T21:59:23.977+08:00 level=INFO source=gpu.go:226 msg="looking for compatible GPUs"
time=2025-02-03T21:59:23.977+08:00 level=INFO source=gpu_windows.go:167 msg=packages count=1
time=2025-02-03T21:59:23.977+08:00 level=INFO source=gpu_windows.go:214 msg="" package=0 cores=10 efficiency=0 threads=20
time=2025-02-03T21:59:24.592+08:00 level=INFO source=types.go:131 msg="inference compute" id=0 library=rocm variant="" compute=gfx803 driver=5.7 name="Radeon RX 580 Series" total="8.0 GiB" available="7.9 GiB"
```

## 运行deepseek-r1:7b

尝试在 AMD RX580 8G 运行 deepseek-r1:7b 大语言模型: `ollama run deepseek-r1:7b`,启动该模型的部分启动日志如下:

```powershell
[GIN] 2025/02/03 - 22:02:45 | 200 |            0s |       127.0.0.1 | HEAD     "/"
[GIN] 2025/02/03 - 22:02:45 | 200 |     54.7458ms |       127.0.0.1 | POST     "/api/show"
time=2025-02-03T22:02:46.336+08:00 level=INFO source=sched.go:185 msg="one or more GPUs detected that are unable to accurately report free memory - disabling default concurrency"
time=2025-02-03T22:02:46.379+08:00 level=INFO source=sched.go:714 msg="new model will fit in available VRAM in single GPU, loading" model=C:\Users\lewlh\.ollama\models\blobs\sha256-96c415656d377afbff962f6cdb2394ab092ccbcbaab4b82525bc4ca800fe8a49 gpu=0 parallel=4 available=8455716864 required="5.6 GiB"
time=2025-02-03T22:02:46.930+08:00 level=INFO source=server.go:104 msg="system memory" total="95.9 GiB" free="83.9 GiB" free_swap="106.4 GiB"
time=2025-02-03T22:02:46.931+08:00 level=INFO source=memory.go:356 msg="offload to rocm" layers.requested=-1 layers.model=29 layers.offload=29 layers.split="" memory.available="[7.9 GiB]" memory.gpu_overhead="0 B" memory.required.full="5.6 GiB" memory.required.partial="5.6 GiB" memory.required.kv="448.0 MiB" memory.required.allocations="[5.6 GiB]" memory.weights.total="4.1 GiB" memory.weights.repeating="3.7 GiB" memory.weights.nonrepeating="426.4 MiB" memory.graph.full="478.0 MiB" memory.graph.partial="730.4 MiB"
time=2025-02-03T22:02:46.947+08:00 level=INFO source=server.go:376 msg="starting llama server" cmd="C:\\Users\\lewlh\\AppData\\Local\\Programs\\Ollama\\lib\\ollama\\runners\\rocm_avx\\ollama_llama_server.exe runner --model C:\\Users\\lewlh\\.ollama\\models\\blobs\\sha256-96c415656d377afbff962f6cdb2394ab092ccbcbaab4b82525bc4ca800fe8a49 --ctx-size 8192 --batch-size 512 --n-gpu-layers 29 --threads 10 --parallel 4 --port 65200"
time=2025-02-03T22:02:47.241+08:00 level=INFO source=sched.go:449 msg="loaded runners" count=1
time=2025-02-03T22:02:47.241+08:00 level=INFO source=server.go:555 msg="waiting for llama runner to start responding"
time=2025-02-03T22:02:47.242+08:00 level=INFO source=server.go:589 msg="waiting for server to become available" status="llm server error"
time=2025-02-03T22:02:47.290+08:00 level=INFO source=runner.go:938 msg="starting go runner"
ggml_cuda_init: GGML_CUDA_FORCE_MMQ:    no
ggml_cuda_init: GGML_CUDA_FORCE_CUBLAS: no
ggml_cuda_init: found 1 ROCm devices:
  Device 0: Radeon RX 580 Series, compute capability 8.0, VMM: no
time=2025-02-03T22:02:48.293+08:00 level=INFO source=runner.go:939 msg=system info="ROCm : NO_PEER_COPY = 1 | PEER_MAX_BATCH_SIZE = 128 | CPU : SSE3 = 1 | SSSE3 = 1 | AVX = 1 | LLAMAFILE = 1 | AARCH64_REPACK = 1 | cgo(gcc)" threads=10
llama_load_model_from_file: using device ROCm0 (Radeon RX 580 Series) - 8064 MiB free
time=2025-02-03T22:02:48.294+08:00 level=INFO source=.:0 msg="Server listening on 127.0.0.1:65200"
llama_model_loader: loaded meta data with 26 key-value pairs and 339 tensors from C:\Users\lewlh\.ollama\models\blobs\sha256-96c415656d377afbff962f6cdb2394ab092ccbcbaab4b82525bc4ca800fe8a49 (version GGUF V3 (latest))
llama_model_loader: Dumping metadata keys/values. Note: KV overrides do not apply in this output.
llama_model_loader: - kv   0:                       general.architecture str              = qwen2
llama_model_loader: - kv   1:                               general.type str              = model
llama_model_loader: - kv   2:                               general.name str              = DeepSeek R1 Distill Qwen 7B
llama_model_loader: - kv   3:                           general.basename str              = DeepSeek-R1-Distill-Qwen
llama_model_loader: - kv   4:                         general.size_label str              = 7B
llama_model_loader: - kv   5:                          qwen2.block_count u32              = 28
llama_model_loader: - kv   6:                       qwen2.context_length u32              = 131072
llama_model_loader: - kv   7:                     qwen2.embedding_length u32              = 3584
llama_model_loader: - kv   8:                  qwen2.feed_forward_length u32              = 18944
llama_model_loader: - kv   9:                 qwen2.attention.head_count u32              = 28
llama_model_loader: - kv  10:              qwen2.attention.head_count_kv u32              = 4
llama_model_loader: - kv  11:                       qwen2.rope.freq_base f32              = 10000.000000
llama_model_loader: - kv  12:     qwen2.attention.layer_norm_rms_epsilon f32              = 0.000001
llama_model_loader: - kv  13:                          general.file_type u32              = 15
llama_model_loader: - kv  14:                       tokenizer.ggml.model str              = gpt2
llama_model_loader: - kv  15:                         tokenizer.ggml.pre str              = qwen2
llama_model_loader: - kv  16:                      tokenizer.ggml.tokens arr[str,152064]  = ["!", "\"", "#", "$", "%", "&", "'", ...
llama_model_loader: - kv  17:                  tokenizer.ggml.token_type arr[i32,152064]  = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
llama_model_loader: - kv  18:                      tokenizer.ggml.merges arr[str,151387]  = ["Ġ Ġ", "ĠĠ ĠĠ", "i n", "Ġ t",...
llama_model_loader: - kv  19:                tokenizer.ggml.bos_token_id u32              = 151646
llama_model_loader: - kv  20:                tokenizer.ggml.eos_token_id u32              = 151643
llama_model_loader: - kv  21:            tokenizer.ggml.padding_token_id u32              = 151643
llama_model_loader: - kv  22:               tokenizer.ggml.add_bos_token bool             = true
llama_model_loader: - kv  23:               tokenizer.ggml.add_eos_token bool             = false
llama_model_loader: - kv  24:                    tokenizer.chat_template str              = {% if not add_generation_prompt is de...
llama_model_loader: - kv  25:               general.quantization_version u32              = 2
llama_model_loader: - type  f32:  141 tensors
llama_model_loader: - type q4_K:  169 tensors
llama_model_loader: - type q6_K:   29 tensors
time=2025-02-03T22:02:48.497+08:00 level=INFO source=server.go:589 msg="waiting for server to become available" status="llm server loading model"
llm_load_vocab: special_eos_id is not in special_eog_ids - the tokenizer config may be incorrect
llm_load_vocab: special tokens cache size = 22
llm_load_vocab: token to piece cache size = 0.9310 MB
llm_load_print_meta: format           = GGUF V3 (latest)
llm_load_print_meta: arch             = qwen2
llm_load_print_meta: vocab type       = BPE
llm_load_print_meta: n_vocab          = 152064
llm_load_print_meta: n_merges         = 151387
llm_load_print_meta: vocab_only       = 0
llm_load_print_meta: n_ctx_train      = 131072
llm_load_print_meta: n_embd           = 3584
llm_load_print_meta: n_layer          = 28
llm_load_print_meta: n_head           = 28
llm_load_print_meta: n_head_kv        = 4
llm_load_print_meta: n_rot            = 128
llm_load_print_meta: n_swa            = 0
llm_load_print_meta: n_embd_head_k    = 128
llm_load_print_meta: n_embd_head_v    = 128
llm_load_print_meta: n_gqa            = 7
llm_load_print_meta: n_embd_k_gqa     = 512
llm_load_print_meta: n_embd_v_gqa     = 512
llm_load_print_meta: f_norm_eps       = 0.0e+00
llm_load_print_meta: f_norm_rms_eps   = 1.0e-06
llm_load_print_meta: f_clamp_kqv      = 0.0e+00
llm_load_print_meta: f_max_alibi_bias = 0.0e+00
llm_load_print_meta: f_logit_scale    = 0.0e+00
llm_load_print_meta: n_ff             = 18944
llm_load_print_meta: n_expert         = 0
llm_load_print_meta: n_expert_used    = 0
llm_load_print_meta: causal attn      = 1
llm_load_print_meta: pooling type     = 0
llm_load_print_meta: rope type        = 2
llm_load_print_meta: rope scaling     = linear
llm_load_print_meta: freq_base_train  = 10000.0
llm_load_print_meta: freq_scale_train = 1
llm_load_print_meta: n_ctx_orig_yarn  = 131072
llm_load_print_meta: rope_finetuned   = unknown
llm_load_print_meta: ssm_d_conv       = 0
llm_load_print_meta: ssm_d_inner      = 0
llm_load_print_meta: ssm_d_state      = 0
llm_load_print_meta: ssm_dt_rank      = 0
llm_load_print_meta: ssm_dt_b_c_rms   = 0
llm_load_print_meta: model type       = 7B
llm_load_print_meta: model ftype      = Q4_K - Medium
llm_load_print_meta: model params     = 7.62 B
llm_load_print_meta: model size       = 4.36 GiB (4.91 BPW)
llm_load_print_meta: general.name     = DeepSeek R1 Distill Qwen 7B
llm_load_print_meta: BOS token        = 151646 '<｜begin▁of▁sentence｜>'
llm_load_print_meta: EOS token        = 151643 '<｜end▁of▁sentence｜>'
llm_load_print_meta: EOT token        = 151643 '<｜end▁of▁sentence｜>'
llm_load_print_meta: PAD token        = 151643 '<｜end▁of▁sentence｜>'
llm_load_print_meta: LF token         = 148848 'ÄĬ'
llm_load_print_meta: FIM PRE token    = 151659 '<|fim_prefix|>'
llm_load_print_meta: FIM SUF token    = 151661 '<|fim_suffix|>'
llm_load_print_meta: FIM MID token    = 151660 '<|fim_middle|>'
llm_load_print_meta: FIM PAD token    = 151662 '<|fim_pad|>'
llm_load_print_meta: FIM REP token    = 151663 '<|repo_name|>'
llm_load_print_meta: FIM SEP token    = 151664 '<|file_sep|>'
llm_load_print_meta: EOG token        = 151643 '<｜end▁of▁sentence｜>'
llm_load_print_meta: EOG token        = 151662 '<|fim_pad|>'
llm_load_print_meta: EOG token        = 151663 '<|repo_name|>'
llm_load_print_meta: EOG token        = 151664 '<|file_sep|>'
llm_load_print_meta: max token length = 256
llm_load_tensors: offloading 28 repeating layers to GPU
llm_load_tensors: offloading output layer to GPU
llm_load_tensors: offloaded 29/29 layers to GPU
llm_load_tensors:   CPU_Mapped model buffer size =   292.36 MiB
llm_load_tensors:        ROCm0 model buffer size =  4168.09 MiB
llama_new_context_with_model: n_seq_max     = 4
llama_new_context_with_model: n_ctx         = 8192
llama_new_context_with_model: n_ctx_per_seq = 2048
llama_new_context_with_model: n_batch       = 2048
llama_new_context_with_model: n_ubatch      = 512
llama_new_context_with_model: flash_attn    = 0
llama_new_context_with_model: freq_base     = 10000.0
llama_new_context_with_model: freq_scale    = 1
llama_new_context_with_model: n_ctx_per_seq (2048) < n_ctx_train (131072) -- the full capacity of the model will not be utilized
llama_kv_cache_init:      ROCm0 KV buffer size =   448.00 MiB
llama_new_context_with_model: KV self size  =  448.00 MiB, K (f16):  224.00 MiB, V (f16):  224.00 MiB
ggml_cuda_host_malloc: failed to allocate 2.38 MiB of pinned memory: out of memory
llama_new_context_with_model:        CPU  output buffer size =     2.38 MiB
ggml_cuda_host_malloc: failed to allocate 23.01 MiB of pinned memory: out of memory
llama_new_context_with_model:      ROCm0 compute buffer size =   492.00 MiB
llama_new_context_with_model:  ROCm_Host compute buffer size =    23.01 MiB
llama_new_context_with_model: graph nodes  = 986
llama_new_context_with_model: graph splits = 2
time=2025-02-03T22:02:53.003+08:00 level=INFO source=server.go:594 msg="llama runner started in 5.76 seconds"
[GIN] 2025/02/03 - 22:02:53 | 200 |     7.268022s |       127.0.0.1 | POST     "/api/generate"
```

Deepseek-r1.7b模型推理的过程，GPU的使用率在90%以上，CPU占用在15%左右，推理的速度还可以：

![运行Deepseek-r1.7b的资源占用情况](/images/202502/Rx580-8GB_RunOllamaDeepseek-r1.7bOnWin11.jpg)

推理的内容:

```powershell
>>> 老虎为什么可以在天上飞，不在地上走?
<think>
嗯，这个问题好像有点奇怪。“老虎为什么可以在天上飞，不在地上走？”听起来像是在问老虎有没有飞行的能力对吧？
可是我已经知道老虎是生活在陆地上的大型猫科动物了。

首先，我想确认一下，“飞”在这里具体指的是什么。如果老虎真的能飞起来，那和它在地面上行走有什么不同呢？

我记得鸟儿是可以飞的，比如飞机机翼的设计就是模仿鸟类飞行时产生的升力。而蝙蝠也是靠超声波导航来飞行的。可是
老虎完全不像这些动物一样有翅膀或者能够飞起来。

接下来，我想了解一下老虎的身体构造。它们的肌肉非常发达，适合地面奔跑和跳跃，但翅膀却很小，不足以支持飞行。


那么，为什么其他动物可以飞而老虎不行呢？这可能跟它们的进化有关吧。鸟类从远古时代的长毛兽演变而来，逐渐发展
出适合飞行的身体结构。而老虎是较晚才适应陆地生活的，所以身体构造不太适合飞翔。

另外，我还想到生物的适应性。大多数生物都是为了一定的生活方式而进化出来的。如果老虎想要学会飞，它可能需要改
变很多生理结构，这在现实中是不现实的。

此外，老虎主要生活在森林里，那里没有那么高的飞行需求。它们通过树上的栖息地和地面上的活动来满足自己的生活需
求，不需要飞起来。

还有，我想到如果老虎真的能够飞起来，那对它的生活方式会有很大的影响。比如，它可以更方便地捕捉猎物，或者在空
中活动时避开危险。

不过，我觉得这可能是一个误解，因为老虎并不是能飞的动物。它们的身体构造和进化都是为了陆地生活，而不是在天空
中活动。

最后，我总结一下：老虎无法飞起来是因为它没有适合飞行的身体结构，这也是鸟类和其他飞行动物进化出来的区别。
</think>

**答案：**

老虎是生活在陆地上的大型猫科动物，它们主要通过奔跑、跳跃等方式捕捉猎物。老虎的身体构造不适合在空中飞行，因
此它们无法飞起来。

总结来说：

1. **身体构造的限制**：老虎拥有发达的地面运动肌肉和骨骼结构，但翅膀小且不够强大来支持飞行。

2. **进化适应陆地生活**：老虎的生理结构是为陆地生活和快速奔跑而优化的，与飞行能力无关。

3. **缺乏飞行所需特征**：鸟类和飞行动物（如飞机机翼）拥有特定的身体构造以产生升力，而老虎不具备这些特征。


因此，老虎无法在天空中飞而在地上行走。
```

## 其它方案

在B站我看到一个博主[司波图](https://www.bilibili.com/video/BV1r7PpeeEBy/?spm_id_from=333.1007.tianma.2-2-5.click&vd_source=3ddb5800edba7dbb68fa507b3abf76b7)做的一期视频，介绍了另外两种方案：

+ 在linux系统下使用专门定制的[docker](https://hub.docker.com/r/mnccouk/ollama-gpu-rx58)镜像运行；
+ 在 windows 系统下使用 LM Studio,利用 vulkan 接口进行推理；

这些方案我没有尝试过，有兴趣的同学可以尝试以下。

## References

+ [ollama-for-amd](https://github.com/likelovewant/ollama-for-amd?tab=readme-ov-file)
+ [ROCmLibs-for-gfx1103-AMD780M-APU](https://github.com/likelovewant/ROCmLibs-for-gfx1103-AMD780M-APU)
+ [AMD HIP SDK for Windows](https://www.amd.com/en/developer/resources/rocm-hub/hip-sdk.html)
+ [OllamaLibraryDeepseekR1](https://ollama.com/library/deepseek-r1)
+ [Ollama终于用上我的显卡坞老古董RX580了](https://phdluffy.com/2024/08/08/ollama-rx580-egpu-amd/)
+ [koboldcpp-rocm](https://github.com/YellowRoseCx/koboldcpp-rocm)
+ [AMD显卡全系列解锁Ollama支持，llama3运行更优雅！](https://www.bilibili.com/opus/923618797070319625?jump_opus=1)
+ [让 AMD 780M 核显也用上 zluda 加速 AI](https://www.bilibili.com/opus/906747525555290131?spm_id_from=333.999.0.0)
+ [mnccouk/ollama-gpu-rx580](https://hub.docker.com/r/mnccouk/ollama-gpu-rx580): Linux 环境下的Docker运行镜像
+ [【550元逆袭！魔改RX580竟能跑14B大模型？实测结果惊呆！】UNRAID部署Deepseek踩坑实录+隐藏彩蛋](https://www.bilibili.com/video/BV1r7PpeeEBy/?spm_id_from=333.1007.tianma.2-2-5.click&vd_source=3ddb5800edba7dbb68fa507b3abf76b7)