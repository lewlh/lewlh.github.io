---
title: CLIP类模型在安防监控视频图像自然语言检索应用中的性能分析报告
date: 2025-05-14 17:50:12
tags:
    - CLIP
    - CCTV
    - Overhead video
    - Deep Research with Gemini 2.5 Pro
---

在视频安防领域，监控摄像头和无人机积累了海量视频数据。这些数据通常仅在有明确目标需求时通过人工查看，成本高且效率低，导致大部分视频数据未被有效利用，长期处于“沉默”状态，甚至最终被销毁。为充分挖掘这些视频数据的价值，我们需要通过抽帧分析提取特征，并支持以自然语言检索视频数据，从而显著提升使用效率、降低成本。要实现这一目标，类似CLIP的模型是关键技术路径。本文主要研究模型的技术水平，帮助技术人员做方案决策。本文由 Deep Research with Gemini 2.5 Pro 撰写。

<!-- more -->

**********

## **1\. 执行摘要**

本报告旨在对开源的CLIP（Contrastive Language-Image Pre-training）及其类似模型（主要包括OpenCLIP、JinaCLIP、SigLIP）在安防监控领域的应用潜力进行深入分析。应用场景聚焦于利用自然语言检索固定视角监控摄像头及无人机采集的视频图像数据，以期降低人力成本、提升数据利用效率。考虑到用户团队暂不具备模型微调能力，本报告将重点评估这些模型的零样本（zero-shot）基线性能，并结合安防数据的独有特性（如固定视角、俯视视角、小目标、多目标、光照变化、图像质量等），探讨其适用性及潜在挑战。同时，报告将详尽分析各模型的推理成本，包括模型大小、硬件需求（CPU/GPU、显存）和推理速度（延迟/吞吐量），为用户选择合适的模型提供决策支持。

核心发现表明，尽管CLIP类模型在通用的图文匹配任务上表现出色，但直接应用于复杂的安防监控场景时，其零样本性能会受到数据特性的显著影响。例如，对小目标、异常姿态以及特定光照条件下的鲁棒性是关键考量。没有任何单一模型能在所有方面（尤其是在兼顾检索准确性和推理成本上）完美胜出。因此，模型的选择将高度依赖于用户在特定应用场景下对检索精度与运营成本之间的权衡。本报告将提供针对性的性能指标和详细的成本分析，以辅助这一决策过程。

## **2\. CLIP类模型用于自然语言视觉检索概述**

近年来，以CLIP为代表的视觉语言预训练模型在连接视觉信息和自然语言理解方面取得了革命性进展，为通过自然语言查询检索图像和视频内容提供了强大的技术基础。

### **2.1. 对比语言-图像预训练（CLIP）的核心原理**

CLIP模型的核心思想在于通过对比学习（contrastive learning）共同训练一个图像编码器和一个文本编码器，使它们能够将图像和文本投影到一个共享的语义嵌入空间中 1。在这个空间里，语义相关的图像和文本对的嵌入向量在空间上更接近，而不相关的则相互远离 3。训练数据通常来源于网络上大量的图像-文本对 2。

这种预训练方式赋予了CLIP模型强大的“零样本”能力。所谓零样本，即模型无需在特定下游任务的数据集上进行微调，就能对未曾见过的类别或概念进行分类或检索 1。例如，通过计算输入图像的嵌入与描述不同类别的文本（如“一只猫的照片”）的嵌入之间的相似度，模型可以判断图像属于哪个类别 5。这一特性对于用户当前不具备微调能力的团队至关重要。

### **2.2. 通用架构概览**

典型的CLIP类模型采用双编码器架构 2：

* **图像编码器（Image Encoder）**: 负责从输入图像中提取视觉特征。常用的图像编码器包括视觉Transformer（Vision Transformer, ViT）或残差网络（ResNet）等。ViT因其利用自注意力机制有效捕捉图像全局和局部细节的能力，在许多CLIP变体中被广泛采用 3。  
* **文本编码器（Text Encoder）**: 负责从输入文本（自然语言查询）中提取文本特征。通常采用Transformer架构 1。

两个编码器独立工作，分别将图像和文本映射到同一维度的嵌入向量，然后在共享空间中计算这些向量的相似度（如余弦相似度），以衡量图文之间的匹配程度。

### **2.3. 与安防监控的关联性**

对于安防监控领域，每天都会产生海量的视频和图像数据。传统的人工审查方式效率低下且成本高昂。CLIP类模型通过自然语言检索视频图像数据的能力，有望彻底改变这一现状（用户查询）。安防人员可以通过输入描述性的自然语言查询（例如“一个穿着红色外套的人在门口徘徊”，“一辆黑色轿车在禁停区停留超过五分钟”）来快速定位相关的视频片段或图像帧，从而大幅缩短调查时间，提高应急响应速度和证据搜集效率。

尽管CLIP的核心原理为通用图文匹配提供了坚实基础，但其直接应用于安防监控的特殊场景时，仍面临诸多挑战。监控画面往往包含复杂的动态场景、多样的目标行为以及由环境因素导致的数据质量问题。模型需要理解的不仅仅是静态物体的标签，更重要的是物体的行为、交互以及场景的上下文。例如，区分“正常路过的人”和“行为可疑的徘徊者”，可能需要模型对细微的视觉线索和潜在的时间序列信息（尽管基础CLIP模型主要处理单帧图像）有更深层次的理解。这些都是在评估其适用性时需要重点考察的方面。

## **3\. 安防监控数据对CLIP类模型的特定挑战**

安防监控数据在视觉特性上与CLIP等模型常用的训练数据（如互联网图文对）存在显著差异。这些差异对模型的零样本检索性能构成了独特的挑战。

### **3.1. 固定视角摄像头（如CCTV）影像特点**

* **静态或可预测的摄像机角度**：监控摄像头通常具有固定的视角，很多是广角镜头，导致画面中物体相对于整个画幅而言尺寸较小 6。这与网络抓取的、通常以主体为中心、目标突出的图像形成对比。  
* **镜头畸变**：安防摄像头，尤其是广角镜头，常出现桶形畸变、枕形畸变或胡须状畸变等光学畸变。如果模型未经校准或对这类畸变不具备鲁棒性，物体外观的失真会影响识别准确率 7。  
* **背景相对固定但存在变化**：虽然背景大部分是静态的，但光照、天气、小物件的移动等因素仍会带来变化。  
* **光照挑战**：光照条件变化剧烈是常态，包括白天到夜晚的转换、强光、阴影、眩光和低照度环境 6。红外（IR）成像在夜间监控中常用，但其提供的视觉信息与可见光图像差异巨大，标准CLIP模型并未针对红外数据进行训练 6。  
* **数据质量**：监控视频可能存在低分辨率、压缩失真和噪声等问题，这些都会影响模型特征提取的质量和后续的检索效果 10。

固定摄像头的“固定性”看似简化了问题，但如果模型的训练数据主要由动态的、以被摄主体为中心的网络图片构成，那么这种固定性反而可能导致“领域偏移”（domain shift）。模型可能过度适应于网络数据中多样化的、居中的主体，而对监控场景中特定的、持续的畸变和静态视角不够鲁棒。这不仅是图像质量问题，更是视觉信息呈现方式的差异。

### **3.2. 俯视/无人机影像特点**

* **顶视视角**：无人机常采用俯视或高空视角拍摄，这与CLIP模型训练数据中常见的地面平视视角显著不同。模型可能因为缺乏此类视角的训练样本而难以准确识别物体。  
* **尺度变化大**：从较高空域拍摄时，地面物体（如人、车辆）在画面中可能非常微小 12。  
* **动态背景与运动模糊**：无人机在移动中拍摄，会导致背景不断变化，并可能引入运动模糊。  
* **云台控制与稳定性**：尽管云台有助于稳定图像，但轻微的角度变化和抖动仍可能存在 12。

无人机影像的俯视视角和小目标尺寸特性带来了复合挑战。CLIP模型在处理小目标方面已知的局限性 14，可能会因为这种非典型视角而进一步加剧。相较于平视视角，俯视视角下的小目标可能呈现更少的独有特征，使得图像编码器更难生成具有区分度的嵌入向量。

### **3.3. 对CLIP类模型检索性能的影响**

* **视角敏感性**：主要基于平视图像训练的模型，在面对固定的高角度或无人机顶视视角时，识别一致性可能下降 16。研究表明CLIP对物体姿态变化较为敏感。  
* **小目标检测与检索**：CLIP（尤其是基于ViT的）倾向于提取全局特征，可能忽略监控中常见的小尺寸但关键的目标或细节 14。例如，检索“手持小型物体的人”这类查询将极具挑战性。  
* **遮挡处理**：在真实场景中，目标部分被其他物体、植被或基础设施遮挡的情况非常普遍 17。遮挡会严重影响检测和检索的准确性。  
* **环境变化鲁棒性**：光照变化 8、天气条件或图像质量问题 10 都可能导致模型性能下降。16的分析也指出CLIP对某些视觉因素变化的鲁棒性有待提高。  
* **区分细粒度活动**：对于在通用图文对上训练的模型而言，区分语义上不同但视觉上细微的动作（例如，“形迹可疑的人”与“等待的人”）可能非常困难。已有研究指出CLIP在细粒度分类任务上存在不足 20。

一个普遍存在于安防监控数据检索中的核心问题是“语义鸿沟”。CLIP模型训练所用的通用网络文本描述与安防场景下具体、通常面向行为或属性的查询之间存在差异。用户可能会查询“有人在爬围墙”或“红色汽车违章停放”，这些查询要求模型具备超越简单物体标记的细致理解能力。例如，CLIP模型在处理多目标场景时，其图像编码器可能偏好大目标，文本编码器可能偏好描述中先提及的目标 15，这对于需要准确理解复杂场景中多个对象及其交互的安防应用而言是一个显著的制约因素。

## **4\. 关键开源CLIP类模型性能评估**

本节将对选定的主流开源CLIP类模型进行性能分析，重点考量其在安防监控视频图像检索任务中的潜力。

### **4.1. 选型模型分析**

选择以下模型家族进行分析，主要基于其开源性质、流行程度、架构多样性及训练数据的差异性：

* **OpenCLIP**:  
  * **变体**: 重点关注基于ViT-B/32和ViT-L/14架构的变体，这些变体使用了如LAION-2B、DataComp等不同的大规模数据集进行训练 2。这些模型代表了不同规模下广泛应用的开源实现。  
  * **架构**: 主要采用ViT作为图像编码器 2。  
* **JinaCLIP**:  
  * **变体**: 包括v1和v2版本 27。JinaCLIP v2提供了多语言支持和更高的输入图像分辨率（512x512），这对于未来的扩展性或处理多样化文本输入可能具有意义，尽管当前主要需求是英文检索。JinaCLIP的一个设计目标是同时提升图文检索和文本-文本检索的性能 27。  
  * **架构**: v1版本结合了Jina BERT v2文本编码器和EVA-02图像编码器 27。v2版本则采用了Jina XLM-RoBERTa文本编码器和EVA02-L14图像编码器 29。  
* **SigLIP**:  
  * **变体**: 重点关注基于ViT-B/16和ViT-L/14（或参数量接近的So400M）架构，并在WebLI等数据集上训练的变体 37。  
  * **架构**: 采用了类似CLIP的框架，但其关键区别在于使用了sigmoid损失函数进行训练，据称这能改善模型性能，尤其是在不同批量大小的情况下 37。

### **4.2. 安防视频/图像检索性能指标**

为了全面评估模型在安防场景下的表现，除了标准的零样本检索指标外，还需考虑针对安防数据特性的特定指标。

* **标准零样本检索指标**:  
  * **Recall@K (R@1, R@5, R@10)**: 用于文本到图像（T2I）和图像到文本（I2T）检索任务，衡量在前K个检索结果中出现正确匹配项的概率 62。K值通常取1, 5, 10。  
  * **平均精度均值 (mAP)**: 提供对排序质量更全面的度量，尤其在多类别或多目标检索中 62。  
* **针对应用的特定性能考量 (定性或定量评估，若有相关研究数据支持)**:  
  * **视角不变性得分**: 评估模型对常见固定摄像头角度（如高位广角）和无人机视角（如俯视）的鲁棒性。这可以从模型在包含此类视角的特定数据集（如VisDrone, UAVDT，若有相关检索结果）上的表现，或从分析姿态敏感性的研究（如 16）中推断。  
  * **小目标检索准确率**: 评估模型在针对微小或远距离目标的查询上的性能。关于CLIP与YOLOv10结合处理小目标的研究 14 以及CLIP对小目标存在偏见的研究 15 在此具有参考价值。  
  * **遮挡处理能力**: 衡量模型检索部分被遮挡目标的能力。遮挡是安防场景中的常见挑战 18。  
  * **图像退化鲁棒性**: 评估模型在模拟或真实的图像退化（如低分辨率 10、恶劣光照 6、压缩失真）下的性能。文献 16 探讨了模型对多种视觉因素的鲁棒性。

### **4.3. 基准性能分析**

#### **4.3.1. 通用零样本检索基准性能**

MS COCO 63 和 Flickr30k 63 是评估图文检索模型性能的常用标准数据集。下表汇总了部分代表性模型在这些数据集上的零样本检索性能。这些基准测试虽然不直接反映安防场景的复杂性，但它们为评估模型基础的图文对齐能力提供了一个重要的参考点。模型在这些通用数据集上的表现差异，可能预示着其在理解基本图文关系方面的固有强弱。

**表1：部分CLIP类模型在MS COCO和Flickr30k上的零样本检索性能对比**

| 模型变体 (预训练数据集) | 参数量 (M) | MS COCO T2I R@1/5/10 (%) | MS COCO I2T R@1/5/10 (%) | Flickr30k T2I R@1/5/10 (%) | Flickr30k I2T R@1/5/10 (%) |
| :---- | :---- | :---- | :---- | :---- | :---- |
| OpenCLIP ViT-B/32 (datacomp\_s1b\_b8k) | 151.3 | 36.2 / 59.6 / 68.8 | 50.1 / 73.8 / 81.8 | 64.0 / 86.2 / 91.4 | 81.7 / 95.8 / 97.9 |
| OpenCLIP ViT-L/14 (laion2b\_s32b\_b82k) | 427.6 | 49.9 / 73.0 / 80.8 | 61.8 / 83.0 / 89.1 | 79.1 / 95.0 / 97.5 | 90.6 / 98.6 / 99.4 |
| JinaCLIP v1 (Jina BERT v2 \+ EVA-02, mixed) | 223 | 79.02 (R@5) | 66.42 (R@5) | 96.40 (R@5) | 89.04 (R@5) |
| JinaCLIP v2 (Jina XLM-R \+ EVA02-L14, mixed) | 865 | 81.46 (R@5) | 68.35 (R@5) | 98.00 (R@5) | 89.84 (R@5) |
| SigLIP ViT-B/16-256px (webli) | 203.2 | 66.1 / 86.3 / 91.8 | 48.3 / 72.5 / 81.0 | 90.4 / 98.3 / 99.3 | 75.0 / 92.4 / 96.3 |
| SigLIP ViT-L/16-384px (webli) | 652.5 | 71.9 / 90.1 / 94.1 | 53.9 / 76.6 / 84.0 | 93.7 / 99.2 / 99.9 | 81.4 / 95.4 / 97.5 |

*注：JinaCLIP v1 和 v2 的性能数据主要来自其官方论文中报告的R@5值 31。OpenCLIP 和 SigLIP 的详细R@1/5/10数据主要来源于 25。参数量参考各模型的技术文档或相关研究。不同来源的评估设置可能存在细微差异。*

#### **4.3.2. 针对安防相关数据集/挑战的性能分析**

尽管直接针对VisDrone、UAVDT或UCF-Crime等安防相关数据集的CLIP类模型零样本*检索*基准数据在现有文献中较为缺乏，但我们可以从相关研究中推断其潜在表现。例如，有研究探讨了在VisDrone上使用CLIP与YOLO结合进行零样本目标检测，并使用mAP和Recall@100作为评估指标 64。UAVDT数据集则突出了无人机视角下目标检测的挑战，如不同飞行高度和天气条件下的目标尺度变化和外观变化 68。UCF-Crime等数据集则被用于评估大型视觉语言模型在视频异常行为理解方面的能力 70。

更为直接的参考来自于对CLIP模型鲁棒性的研究。文献 16 对CLIP模型在多种视觉因素（包括姿态/视角、尺度、背景等）下的鲁棒性进行了评估。研究发现，CLIP模型对物体姿态（视角）的变化相对不鲁棒，但对尺度和纹理变化表现出较好的鲁棒性。这对安防应用具有重要启示：固定摄像头的高角度或无人机的俯视视角可能对CLIP的性能构成挑战，而其对物体大小变化的鲁棒性则是一个优势。

关于小目标检索，研究 14 提出通过结合YOLOv10来提升CLIP在小目标和复杂背景下的检索能力。而另一项研究 15 指出，CLIP的图像编码器倾向于关注大目标，文本编码器则可能优先处理描述中首先提及的对象，这对于包含多个目标和复杂活动的监控场景来说是不利的。

标准基准测试（如MS COCO/Flickr30k）的成绩可能无法完全预测模型在安防数据上的表现，因为安防数据在视觉特征和查询类型上均有其独特性。因此，对模型鲁棒性的研究（如 16）以及针对小目标检索等特定挑战的分析（如 14），为用户在安防领域的应用提供了更直接的性能参考。

此外，需要注意的是“零样本”的定义本身也可能存在细微差别。虽然模型未在目标数据集上进行微调，但用于零样本分类或检索的提示（prompt）对性能有显著影响 49。对于用户通过自然语言进行检索的任务而言，用户的查询本身即是“提示”。模型对用户多样化自然语言表达的泛化能力至关重要。

## **5\. 推理成本与部署考量**

在选择模型时，除了性能表现，推理成本和部署可行性也是至关重要的因素。这包括模型大小、硬件需求（尤其是显存VRAM）以及推理速度（延迟和吞吐量）。

### **5.1. 模型大小**

* **参数量**:  
  * OpenCLIP ViT-B/32 (datacomp): 约1.51亿 25。  
  * OpenCLIP ViT-L/14 (laion2b): 约4.28亿 20。  
  * JinaCLIP v1: 2.23亿 27。  
  * JinaCLIP v2: 总计8.65亿 (文本编码器5.61亿，图像编码器3.04亿) 29。  
  * SigLIP ViT-B/16 (256px, webli): 约2.03亿 25。  
  * SigLIP ViT-L/16 (384px, webli): 约6.52亿 25。  
* **磁盘存储 (MB/GB)**: 模型检查点文件的大小。  
  * OpenCLIP ViT-B/32: FP16精度下约288-302MB 77。  
  * OpenCLIP ViT-L/14: FP16精度下约856MB（基于4.28亿参数估算）。DINOv2 ViT-L/14约为1.13GB 78。  
  * JinaCLIP v1: FP32精度下约892MB，FP16精度下约446MB 79。  
  * JinaCLIP v2: FP16精度下约1.73GB 35。  
  * SigLIP ViT-B/16: FP16精度下约406MB。  
  * SigLIP ViT-L/16-384px: FP16精度下约1.3GB。  
  * 需要注意，open\_clip\_torch等库本身的安装包很小（如1.4MB 80），这里指的是模型权重文件的大小。

### **5.2. 硬件需求**

* **CPU vs. GPU**: 对于大多数CLIP类模型的推理，GPU通常远快于CPU。尽管对于小模型或低吞吐量需求，CPU可能成本更低 82，但考虑到安防检索任务可能涉及大量数据和对实时性的要求，GPU可能是必要的。  
* **GPU型号**: 不同型号的GPU（如NVIDIA T4, V100, A100以及更新的Blackwell系列，AMD MI325X等）性能差异显著 80。选择时需平衡性能与预算。  
* **显存 (VRAM) 消耗**: 这是加载和运行模型的关键瓶颈。模型越大，所需显存越多。  
  * OpenAI CLIP ViT-Base-patch32: 推理时FP16权重约需288MB显存 77。  
  * JinaCLIP v2: 处理单张512x512图像（FP16）时，有用户报告称占用了6GB显存 93。这表明其图像处理流程（可能涉及分块处理高分辨率图像）对显存需求较高。  
  * 一般而言，FP16模型权重约占每参数2字节的存储空间。

### **5.3. 推理速度**

* **延迟 (ms/查询)**: 处理单个查询所需的时间，对实时应用非常重要。  
  * OpenCLIP ViT-B/32 (datacomp) 在CPU (12代 Intel i7) 上图像编码约114毫秒/帧 94。  
  * OpenCLIP ViT-B/32 在GPU (RTX 3090\) 上图像编码约6.3毫秒/帧 94。  
  * Marqo基准测试中，OpenCLIP ViT-B/32 (laion2b) 在T4上文本推理7.6ms，图像推理8.4ms；在A10g上文本推理3.2ms，图像推理3.4ms 95。  
  * Marqo基准测试中，OpenCLIP ViT-L/14 (laion2b) 在T4上文本推理20.8ms，图像推理42.8ms；在A10g上文本推理8.4ms，图像推理16.2ms 95。  
  * SigLIP ViT-L/16-384px: 有报告称“几秒钟处理一张图片” 96 或“非常快” 98。Marqo基准测试中，在T4上文本推理20.9ms，图像推理49.9ms；在A10g上文本推理8.3ms，图像推理19.0ms 95。  
  * SigLIP ViT-B/16: 有报告称“毫秒级处理一张图片” 51。Marqo基准测试中，在T4上文本推理7.8ms，图像推理9.8ms；在A10g上文本推理3.2ms，图像推理3.9ms 95。  
* **吞吐量 (查询/秒)**: 单位时间内处理的查询数量，对批量处理或高并发系统很重要。  
  * 使用clip-retrieval工具（基于OpenCLIP）在RTX 3080上可达到1500样本/秒的处理速度 99。  
  * NVIDIA Triton 推理服务器通过动态批处理和多模型实例等技术可以显著提升吞吐量 100。

下表总结了部分代表性模型的推理成本相关信息。

**表2：部分CLIP类模型推理成本对比分析**

| 模型变体 (预训练数据集) | 参数量 (M) | 磁盘大小 (FP16估算) | GPU型号 (示例) | 文本推理延迟 (ms) | 图像推理延迟 (ms) | VRAM占用 (估算/报告) |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| OpenCLIP ViT-B/32 (datacomp\_s1b\_b8k) | 151.3 | \~302 MB | T4 / A10g | 7.6 / 3.2 | 8.4 / 3.4 | \~300MB / 较低 |
| OpenCLIP ViT-L/14 (laion2b\_s32b\_b82k) | 427.6 | \~856 MB | T4 / A10g | 20.8 / 8.4 | 42.8 / 16.2 | 中等 |
| JinaCLIP v1 (mixed) | 223 | \~446 MB (FP16) | \- | \- | \- | 较低-中等 |
| JinaCLIP v2 (mixed) | 865 | \~1.73 GB | 高性能GPU | 较快 (优化后) | 较快 (优化后) | 较高 (单图6GB报告) |
| SigLIP ViT-B/16-256px (webli) | 203.2 | \~406 MB | T4 / A10g | 7.8 / 3.2 | 9.8 / 3.9 | 较低-中等 |
| SigLIP ViT-L/16-384px (webli) | 652.5 | \~1.3 GB | T4 / A10g | 20.9 / 8.3 | 49.9 / 19.0 | 中等-较高 |

*注：延迟数据主要参考Marqo基准测试 95 在T4和A10g上的表现。VRAM占用除JinaCLIP v2有具体报告外，其余多为基于模型大小的估算。实际表现会因具体硬件、批处理大小、软件优化（如TensorRT, OpenVINO 49）等因素而异。JinaCLIP v2的VRAM报告 93 提示高分辨率图像处理可能对显存有较高要求。*

推理成本并非仅由模型大小决定，还与具体实现、可用的优化工具（如ONNX、TensorRT、OpenVINO）以及所用硬件密切相关。JinaCLIP v2在高分辨率图像处理时的高显存占用是一个需要特别注意的信号，尤其对于可能采用高分辨率无人机或固定摄像头的用户。

CPU与GPU的选择也并非绝对，它取决于模型大小、批处理大小以及对延迟和吞吐量的具体需求。对于安防这类可能需要近实时响应或处理大量数据的任务，特别是使用较大型CLIP变体时，GPU几乎是保证满意性能的必需品。即便是参数量低于10亿的模型，如果需要处理高分辨率图像或追求低延迟，CPU的性能（如OpenCLIP ViT-B/32在CPU上图像编码耗时100+毫秒 94）可能难以满足大规模高效检索或实时应用的需求。

## **6\. 模型选型比较分析与建议**

基于前述对模型性能和成本的分析，本节将对各模型家族在安防监控应用中的优劣势进行总结，并提供选型建议。

### **6.1. 各模型家族针对安防监控的优劣势分析**

* **OpenCLIP**:  
  * **优势**: 拥有广泛的模型尺寸和预训练数据集选择 24，开源社区活跃，在通用基准上展现出良好的基线性能。部分大型变体（如ViT-G/14）的零样本准确率非常高 22。  
  * **劣势**: 性能随训练数据不同而有较大差异。可能继承了通用CLIP模型在处理小目标、细粒度细节方面的局限性，以及对特定视觉因素（如姿态）的鲁棒性问题 15。  
* **JinaCLIP**:  
  * **优势**: 其设计目标是同时优化文本到文本和文本到图像的检索性能 27，这可能使其能更好地理解细致或复杂的自然语言查询。JinaCLIP v2支持更高分辨率的图像输入（512x512）和多语言能力 29，并引入了灵活的嵌入维度（Matryoshka表示学习）29。在视觉文档检索方面也有性能提升 31。  
  * **劣势**: JinaCLIP v1仅支持英文 30。JinaCLIP v2虽然功能强大，但模型参数量较大（8.65亿），且有报告指出其在图像处理时显存占用较高 93，可能导致较高的推理成本。  
* **SigLIP**:  
  * **优势**: 采用sigmoid损失函数，据称能在较小批量下获得更好性能，并且易于扩展 37。通常具有良好的零样本性能，在ImageNet等基准上有时优于标准CLIP 37。部分变体支持更高的输入分辨率（如384px, 512px 25）。  
  * **劣势**: 其核心架构仍与CLIP类似，因此可能在特定安防挑战（如小目标识别、复杂场景理解）方面存在相似的局限性，除非有特定变体针对这些问题进行了优化。若输入的文本与训练数据（如WebLI）差异较大，性能可能会受影响 51。

### **6.2. 权衡：准确性 vs. 速度 vs. 成本**

在模型选择中，通常需要在检索准确性、推理速度和部署成本之间进行权衡。

* **大型模型** (如OpenCLIP ViT-L/H/G系列, JinaCLIP v2, SigLIP ViT-L系列) 通常在基准测试中展现出更高的检索准确率，但伴随而来的是更高的计算成本，包括对显存、GPU性能的要求更高，以及可能更长的处理延迟 22。  
* **小型模型** (如OpenCLIP ViT-B系列, SigLIP ViT-B系列) 运行速度更快，成本更低，但可能在处理复杂查询或识别细微视觉差异时表现稍逊 51。

### **6.3. 模型选型指导**

基于不同安防场景的特点和需求，提出以下选型倾向：

* **针对固定广角摄像头**:  
  * 优先考虑对尺度变化鲁棒性较好，并可能对镜头畸变有一定适应性的模型。视角鲁棒性是一个普遍关注点 16；在更多样化数据上训练的模型可能略有优势。  
  * 若源视频分辨率较高，JinaCLIP v2的512x512输入分辨率可能带来益处，但需注意其显存消耗。  
* **针对无人机/俯视视角**:  
  * 小目标检索能力是核心。可以考察SigLIP或OpenCLIP中在细粒度任务上表现较好的变体。然而，模型普遍存在对小目标的偏见 15 是一个主要障碍。非典型视角对所有模型都是挑战。  
* **优先实时警报（低延迟需求）**:  
  * 应首选小型模型（如ViT-B系列）或针对速度进行过特定优化的模型（例如，MobileCLIP系列 53 若作为主要考虑对象，或参考 95 中关于最快推理速度的讨论）。这可能意味着在一定程度上牺牲准确性。  
* **优先事后分析（可容忍较高延迟，追求高准确率）**:  
  * 如果准确性是首要目标，且处理时间不那么关键，可以考虑大型模型（如ViT-L/H/G系列, JinaCLIP v2）。  
* **预算限制**:  
  * 若硬件预算非常有限（例如仅CPU或低端GPU），则只有最小型、最高效的模型是可行的，但预期性能会有所下降。

下表提供了一个针对安防监控适用性的总结比较矩阵，旨在帮助用户根据其具体业务优先级来缩小选择范围。此表超越了通用的基准分数，而是针对安防数据的独有挑战（如固定/俯视视角、小目标、鲁棒性）和实际部署限制（推理效率）进行评估。

**表3：CLIP类模型安防监控适用性总结比较矩阵**

| 模型家族/变体 (代表) | 核心架构差异 | 估算参数量 | 输入分辨率 | 固定视角适宜性 (视角/畸变鲁棒性) | 俯视/无人机适宜性 (小目标/顶视) | 光照/退化鲁棒性 | 推理效率 (速度/成本综合) | 安防场景关键优势 | 安防场景关键劣势 |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| OpenCLIP (ViT-L/14) | 标准ViT编码器, 多种预训练数据 | \~428M | 224x224 | 中 (对姿态敏感 16) | 中-低 (对小目标敏感 15) | 中-高 (对尺度/纹理较好) | 中 | 广泛选择, 社区支持, 大型号性能强 | 视角/小目标敏感性, 性能依赖训练数据 |
| JinaCLIP v2 | XLM-R文本编码器, EVA02图像编码器, 支持长文本/高分 | 865M | 512x512 | 中-高 (高分辨率输入) | 中 (高分辨率可能缓解小目标问题) | 中 | 低-中 (显存需求高 93) | 优异文本理解, 高分辨率图像处理, 多语言 | 模型较大, 显存消耗高, 推理成本可能较高 |
| SigLIP (ViT-L/16-384px) | Sigmoid损失函数, ViT编码器 | \~652M | 384x384 | 中 (类似OpenCLIP) | 中 (类似OpenCLIP) | 中-高 | 中 | 较小批次下性能好, 扩展性好, 零样本性能佳 | 可能继承CLIP对特定挑战的局限性, 对训练数据外文本的泛化性需注意 51 |
| OpenCLIP (ViT-B/32) | 标准ViT编码器, 多种预训练数据 | \~151M | 224x224 | 中 (对姿态敏感) | 低 (对小目标敏感) | 中 | 高 | 推理成本低, 速度快 | 复杂场景/小目标准确率可能较低 |
| SigLIP (ViT-B/16-256px) | Sigmoid损失函数, ViT编码器 | \~203M | 256x256 | 中 (类似OpenCLIP) | 低-中 (类似OpenCLIP) | 中 | 高 | 推理成本较低, 速度较快, 较小批次性能好 | 复杂场景/小目标准确率可能较低 |

“最佳”模型高度依赖于具体应用场景。在通用基准上表现优异的模型，如果其训练数据未覆盖相似的视觉特征，或者模型本身存在固有偏见（例如对小目标的识别能力不足），则在特定的安防场景中可能会表现不佳。用户需要权衡这些特定的失效模式与通用性能。

考虑到用户无法进行微调，预训练模型对安防场景中用户将提出的*特定类型自然语言查询*的固有零样本泛化能力至关重要。安防查询可能涉及复杂的场景描述和行为判断，例如“查找所有在凌晨2点到3点间在后门附近徘徊的穿红色衬衫的人”。虽然时间维度的理解超出了单帧CLIP模型的范畴，但描述性部分（如“红色衬衫”，“徘徊”，“后门”）仍需要良好的视觉语言对齐。JinaCLIP明确致力于提升文本-文本检索能力及支持长文本上下文 27，这可能使其在理解更复杂或描述性更强的查询方面具有一定优势，即便其图像处理对资源要求较高。

## **7\. 结论与未来展望**

本报告对OpenCLIP、JinaCLIP和SigLIP等主流开源CLIP类模型在安防监控视频图像自然语言检索应用中的零样本性能和推理成本进行了分析。核心结论如下：

1. **性能与成本的权衡是关键**：大型模型（如OpenCLIP ViT-L/H/G、JinaCLIP v2、SigLIP ViT-L）通常在通用基准上表现更优，但在安防特定挑战（如小目标、非典型视角、复杂行为理解）面前，其零样本优势可能减弱，且推理成本（硬件、时间）显著更高。小型模型（如OpenCLIP ViT-B、SigLIP ViT-B）成本较低、速度更快，但在复杂场景下的检索精度可能不足。  
2. **安防数据特性带来挑战**：固定摄像头的静态高位视角、无人机的俯视视角、常见的光照变化、图像质量问题、目标遮挡以及小目标识别等，均对主要在通用网络图文数据上预训练的CLIP模型构成挑战。特别是视角敏感性（姿态变化）和小目标识别能力是当前零样本CLIP类模型应用于安防监控的主要瓶颈。  
3. **JinaCLIP v2的潜力与代价**：JinaCLIP v2凭借其对高分辨率图像的处理能力和对长文本的更强理解潜力，在理论上可能更适合处理细节丰富的安防影像和复杂查询。然而，其较大的模型体积和报告的高显存占用，意味着更高的部署门槛和运行成本。  
4. **SigLIP的效率优势**：SigLIP通过改进损失函数，在保持良好零样本性能的同时，可能在训练效率和不同批次大小下的稳定性方面具有优势，但其在安防特定挑战上的表现仍需进一步验证。  
5. **OpenCLIP的多样性**：OpenCLIP提供了最广泛的模型和预训练数据选择，为用户提供了根据具体需求（如模型大小、特定预训练数据源）进行初步筛选的灵活性。

**最终模型选型建议**：

* **若优先考虑低成本和快速部署验证**：可以从**OpenCLIP ViT-B/32**或**SigLIP ViT-B/16**（如256px输入版本）入手。它们参数量较小，推理成本相对较低，可在CPU或中低端GPU上运行。预期在简单场景和清晰目标下能获得一定的检索效果，但对复杂场景、小目标、恶劣光照等情况下的性能期望不宜过高。  
* **若追求更高的检索准确率，且具备中高端GPU资源**：可以考虑**OpenCLIP ViT-L/14**或**SigLIP ViT-L/16**（如384px输入版本）。它们在通用基准上表现更强，但需要关注其在安防特定挑战（如视角、小目标）下的实际表现。  
* **若处理高分辨率图像（如部分无人机影像）且查询语句可能较为复杂，并能接受较高的硬件成本**：可以评估**JinaCLIP v2**。其对512x512图像的支持和长文本处理能力是优势，但务必充分测试其显存占用和推理速度是否满足实际需求。

由于用户暂不具备微调能力，强烈建议在选定候选模型后，利用少量代表性的自有安防数据进行实际的零样本检索测试，以直观评估其在真实场景中的表现。

**未来展望**：

视觉语言模型领域发展迅速。未来可能出现更多针对特定领域（如监控）、具有更强鲁棒性（如对视角、小目标）、更高推理效率的开源模型。尽管当前用户不进行微调，但未来若条件允许，诸如提示工程（prompt engineering）、适配器（adapter）微调等轻量级调整技术，也可能在不消耗大量资源的情况下提升模型在特定任务上的性能。本报告建立的评估框架和对挑战的理解，将对用户评估未来出现的新模型和技术持续提供价值。

## **引用的著作**

1. Building CLIP from Scratch: A Tutorial on Multi-Modal Learning \- Ready Tensor, 访问时间为 五月 14, 2025， [https://app.readytensor.ai/publications/building-clip-from-scratch-a-tutorial-on-multimodal-learning-57Nhu0gMyonV](https://app.readytensor.ai/publications/building-clip-from-scratch-a-tutorial-on-multimodal-learning-57Nhu0gMyonV)  
2. Contrastive Language-Image Pre-training \- Wikipedia, 访问时间为 五月 14, 2025， [https://en.wikipedia.org/wiki/Contrastive\_Language-Image\_Pre-training](https://en.wikipedia.org/wiki/Contrastive_Language-Image_Pre-training)  
3. Enhancing Multimodal Understanding with CLIP-Based Image-to-Text Transformation, 访问时间为 五月 14, 2025， [https://arxiv.org/html/2401.06167v1](https://arxiv.org/html/2401.06167v1)  
4. CLIP: Connecting text and images \- OpenAI, 访问时间为 五月 14, 2025， [https://openai.com/index/clip/](https://openai.com/index/clip/)  
5. openai/CLIP: CLIP (Contrastive Language-Image ... \- GitHub, 访问时间为 五月 14, 2025， [https://github.com/openai/CLIP](https://github.com/openai/CLIP)  
6. Define Surveillance Camera: A Complete Guide \- Stealth Monitoring, 访问时间为 五月 14, 2025， [https://stealthmonitoring.com/security-blog/define-surveillance-camera-a-complete-guide](https://stealthmonitoring.com/security-blog/define-surveillance-camera-a-complete-guide)  
7. 2025 Vision AI Camera Calibration \- Ultralytics, 访问时间为 五月 14, 2025， [https://www.ultralytics.com/blog/a-guide-to-camera-calibration-for-computer-vision-in-2025](https://www.ultralytics.com/blog/a-guide-to-camera-calibration-for-computer-vision-in-2025)  
8. Tech Papers: Lighting for Facial Biometrics | AIA, 访问时间为 五月 14, 2025， [https://www.automate.org/vision/tech-papers/lighting-for-facial-biometrics](https://www.automate.org/vision/tech-papers/lighting-for-facial-biometrics)  
9. Diverse Lighting Face Recognition: AI Enhancing Accuracy \- FaceOnLive : On-Premises ID Verification & Biometrics Solution Provider, 访问时间为 五月 14, 2025， [https://faceonlive.com/diverse-lighting-face-recognition-ai-enhancing-accuracy/](https://faceonlive.com/diverse-lighting-face-recognition-ai-enhancing-accuracy/)  
10. Why Are Security Cameras So Low Quality \[Answered\] \- Eufy, 访问时间为 五月 14, 2025， [https://www.eufy.com/blogs/security-camera/why-are-security-cameras-so-low-quality](https://www.eufy.com/blogs/security-camera/why-are-security-cameras-so-low-quality)  
11. AI In Security Cameras: Real Change Or Hype? | Tech Focus \- Electronics For You, 访问时间为 五月 14, 2025， [https://www.electronicsforu.com/technology-trends/ai-in-security-cameras-real-change-or-hype](https://www.electronicsforu.com/technology-trends/ai-in-security-cameras-real-change-or-hype)  
12. Drones For Surveillance: The Ultimate Guide \- FlytBase, 访问时间为 五月 14, 2025， [https://www.flytbase.com/blog/drone-surveillance-system](https://www.flytbase.com/blog/drone-surveillance-system)  
13. How Drones Are Used for Better Surveillance & Security? \- IoTechWorld, 访问时间为 五月 14, 2025， [https://iotechworld.com/how-drones-are-used-for-better-surveillance-security/](https://iotechworld.com/how-drones-are-used-for-better-surveillance-security/)  
14. Enhanced image-text retrieval based on CLIP with YOLOv10 and Next-ViT, 访问时间为 五月 14, 2025， [https://www.spiedigitallibrary.org/conference-proceedings-of-spie/13486/134862K/Enhanced-image-text-retrieval-based-on-CLIP-with-YOLOv10-and/10.1117/12.3055876.full](https://www.spiedigitallibrary.org/conference-proceedings-of-spie/13486/134862K/Enhanced-image-text-retrieval-based-on-CLIP-with-YOLOv10-and/10.1117/12.3055876.full)  
15. Analyzing CLIP's Performance Limitations in Multi-Object Scenarios: A Controlled High-Resolution Study \- arXiv, 访问时间为 五月 14, 2025， [https://arxiv.org/html/2502.19828v1](https://arxiv.org/html/2502.19828v1)  
16. arxiv.org, 访问时间为 五月 14, 2025， [https://arxiv.org/abs/2402.07410](https://arxiv.org/abs/2402.07410)  
17. Choosing the Right Motion Capture Solution: Sensor-Based Suits and Gloves vs. Camera-Based AI Vision \- Rokoko, 访问时间为 五月 14, 2025， [https://www.rokoko.com/insights/motion-capture-suit-vs-vision-ai-camera-mocap](https://www.rokoko.com/insights/motion-capture-suit-vs-vision-ai-camera-mocap)  
18. Video Object Tracking Made Easy: Problems and Solutions, 访问时间为 五月 14, 2025， [https://www.atltranslate.com/ai/blog/video-object-tracking-problems-solutions](https://www.atltranslate.com/ai/blog/video-object-tracking-problems-solutions)  
19. How does occlusion affect the performance of object detection models in real-world scenarios? \- Massed Compute, 访问时间为 五月 14, 2025， [https://massedcompute.com/faq-answers/?question=How%20does%20occlusion%20affect%20the%20performance%20of%20object%20detection%20models%20in%20real-world%20scenarios?](https://massedcompute.com/faq-answers/?question=How+does+occlusion+affect+the+performance+of+object+detection+models+in+real-world+scenarios?)  
20. openai/clip-vit-large-patch14 · Hugging Face, 访问时间为 五月 14, 2025， [https://huggingface.co/openai/clip-vit-large-patch14](https://huggingface.co/openai/clip-vit-large-patch14)  
21. openclip-b \- Kaggle, 访问时间为 五月 14, 2025， [https://www.kaggle.com/datasets/humbleyll/openclip-b](https://www.kaggle.com/datasets/humbleyll/openclip-b)  
22. Reaching 80% zero-shot accuracy with OpenCLIP: ViT-G/14 trained on LAION-2B, 访问时间为 五月 14, 2025， [https://laion.ai/blog/giant-openclip/](https://laion.ai/blog/giant-openclip/)  
23. Large scale openCLIP: L/14, H/14 and g/14 trained on LAION-2B ..., 访问时间为 五月 14, 2025， [https://laion.ai/blog/large-openclip/](https://laion.ai/blog/large-openclip/)  
24. openclip · 90bfad114813389a01a8d98e29d15458929a2e30 · William Eriksson / Deep\_Learning\_Project \- GitLab, 访问时间为 五月 14, 2025， [https://scolopendra.it.liu.se/wiler441/Deep\_Learning\_Project/-/tree/90bfad114813389a01a8d98e29d15458929a2e30/openclip](https://scolopendra.it.liu.se/wiler441/Deep_Learning_Project/-/tree/90bfad114813389a01a8d98e29d15458929a2e30/openclip)  
25. open\_clip/docs/openclip\_retrieval\_results.csv at main \- GitHub, 访问时间为 五月 14, 2025， [https://github.com/mlfoundations/open\_clip/blob/main/docs/openclip\_retrieval\_results.csv](https://github.com/mlfoundations/open_clip/blob/main/docs/openclip_retrieval_results.csv)  
26. mlfoundations/open\_clip: An open source implementation ... \- GitHub, 访问时间为 五月 14, 2025， [https://github.com/mlfoundations/open\_clip](https://github.com/mlfoundations/open_clip)  
27. jina-clip-v1 \- Search Foundation Models \- Jina AI, 访问时间为 五月 14, 2025， [https://jina.ai/models/jina-clip-v1/](https://jina.ai/models/jina-clip-v1/)  
28. Jina Clip \- Dataloop, 访问时间为 五月 14, 2025， [https://dataloop.ai/library/model/tag/jina\_clip/](https://dataloop.ai/library/model/tag/jina_clip/)  
29. jina-clip-v2 \- Search Foundation Models \- Jina AI, 访问时间为 五月 14, 2025， [https://jina.ai/models/jina-clip-v2/](https://jina.ai/models/jina-clip-v2/)  
30. jina-clip-v2: Multilingual Multimodal Embeddings for Text and Images \- arXiv, 访问时间为 五月 14, 2025， [https://arxiv.org/html/2412.08802v1](https://arxiv.org/html/2412.08802v1)  
31. jina-clip-v2: Multilingual Multimodal Embeddings for Text and Images \- arXiv, 访问时间为 五月 14, 2025， [https://arxiv.org/html/2412.08802v2](https://arxiv.org/html/2412.08802v2)  
32. 访问时间为 一月 1, 1970， [https://huggingface.co/collections/jinaai/jina-clip-6556935160851a3499190701](https://huggingface.co/collections/jinaai/jina-clip-6556935160851a3499190701)  
33. arxiv.org, 访问时间为 五月 14, 2025， [https://arxiv.org/abs/2401.00862](https://arxiv.org/abs/2401.00862)  
34. arxiv.org, 访问时间为 五月 14, 2025， [https://arxiv.org/abs/2312.16201](https://arxiv.org/abs/2312.16201)  
35. jinaai/jina-clip-v2 \- Hugging Face, 访问时间为 五月 14, 2025， [https://huggingface.co/jinaai/jina-clip-v2](https://huggingface.co/jinaai/jina-clip-v2)  
36. arxiv.org, 访问时间为 五月 14, 2025， [https://arxiv.org/abs/2412.08802](https://arxiv.org/abs/2412.08802)  
37. SigLIP Classification Model: What is, How to Use \- Roboflow, 访问时间为 五月 14, 2025， [https://roboflow.com/model/siglip](https://roboflow.com/model/siglip)  
38. Siglip Base Patch16 512 · Models · Dataloop, 访问时间为 五月 14, 2025， [https://dataloop.ai/library/model/google\_siglip-base-patch16-512/](https://dataloop.ai/library/model/google_siglip-base-patch16-512/)  
39. transformers/docs/source/en/model\_doc/siglip.md at main \- GitHub, 访问时间为 五月 14, 2025， [https://github.com/huggingface/transformers/blob/main/docs/source/en/model\_doc/siglip.md](https://github.com/huggingface/transformers/blob/main/docs/source/en/model_doc/siglip.md)  
40. Projects based on SigLIP (Zhai et. al, 2023\) and Hugging Face transformers integration \- GitHub, 访问时间为 五月 14, 2025， [https://github.com/merveenoyan/siglip](https://github.com/merveenoyan/siglip)  
41. Siglip Base Patch16 224 · Models \- Dataloop AI, 访问时间为 五月 14, 2025， [https://dataloop.ai/library/model/google\_siglip-base-patch16-224/](https://dataloop.ai/library/model/google_siglip-base-patch16-224/)  
42. Siglip So400m Patch16 256 I18n · Models \- Dataloop, 访问时间为 五月 14, 2025， [https://dataloop.ai/library/model/google\_siglip-so400m-patch16-256-i18n/](https://dataloop.ai/library/model/google_siglip-so400m-patch16-256-i18n/)  
43. visheratin/mexma-siglip2 · How to Optimize Slow CPU Inference Speed \- Hugging Face, 访问时间为 五月 14, 2025， [https://huggingface.co/visheratin/mexma-siglip2/discussions/2](https://huggingface.co/visheratin/mexma-siglip2/discussions/2)  
44. SigLIP 2: Multilingual Vision-Language Encoders with Improved Semantic Understanding, Localization, and Dense Features \- arXiv, 访问时间为 五月 14, 2025， [https://arxiv.org/html/2502.14786v1](https://arxiv.org/html/2502.14786v1)  
45. Image Retrieval with Short Text Queries \- CEUR-WS.org, 访问时间为 五月 14, 2025， [https://ceur-ws.org/Vol-3910/aics2024\_p46.pdf](https://ceur-ws.org/Vol-3910/aics2024_p46.pdf)  
46. ELIP: Enhanced Visual-Language Foundation Models for Image Retrieval \- arXiv, 访问时间为 五月 14, 2025， [https://arxiv.org/html/2502.15682v1](https://arxiv.org/html/2502.15682v1)  
47. arXiv:2503.06626v1 \[cs.CV\] 9 Mar 2025 \- alphaXiv, 访问时间为 五月 14, 2025， [https://fetcher.alphaxiv.org/v2/pdf/2503.06626v1](https://fetcher.alphaxiv.org/v2/pdf/2503.06626v1)  
48. An Enhanced CLIP Framework for Learning with Synthetic Captions, 访问时间为 五月 14, 2025， [https://ucsc-vlaa.github.io/CLIPS/](https://ucsc-vlaa.github.io/CLIPS/)  
49. Zero-shot Image Classification with SigLIP \- OpenVINO™ documentation, 访问时间为 五月 14, 2025， [https://docs.openvino.ai/2025/notebooks/siglip-zero-shot-image-classification-with-output.html](https://docs.openvino.ai/2025/notebooks/siglip-zero-shot-image-classification-with-output.html)  
50. This Visual Illusions Benchmark Makes Me Question the Power of VLMs \- Voxel51, 访问时间为 五月 14, 2025， [https://voxel51.com/blog/this-visual-illusions-benchmark-makes-me-question-the-power-of-vlms/](https://voxel51.com/blog/this-visual-illusions-benchmark-makes-me-question-the-power-of-vlms/)  
51. ViT B 16 SigLIP · Models \- Dataloop AI, 访问时间为 五月 14, 2025， [https://dataloop.ai/library/model/timm\_vit-b-16-siglip/](https://dataloop.ai/library/model/timm_vit-b-16-siglip/)  
52. timm/ViT-B-16-SigLIP2-512 \- Hugging Face, 访问时间为 五月 14, 2025， [https://huggingface.co/timm/ViT-B-16-SigLIP2-512](https://huggingface.co/timm/ViT-B-16-SigLIP2-512)  
53. Visual Content Search using MobileCLIP and OpenVINO, 访问时间为 五月 14, 2025， [https://docs.openvino.ai/2025/notebooks/mobileclip-video-search-with-output.html](https://docs.openvino.ai/2025/notebooks/mobileclip-video-search-with-output.html)  
54. SigLIP \- Hugging Face, 访问时间为 五月 14, 2025， [https://huggingface.co/docs/transformers/model\_doc/siglip](https://huggingface.co/docs/transformers/model_doc/siglip)  
55. google/siglip-large-patch16-384 · Hugging Face, 访问时间为 五月 14, 2025， [https://huggingface.co/google/siglip-large-patch16-384](https://huggingface.co/google/siglip-large-patch16-384)  
56. Modeling Caption Diversity in Contrastive Vision-Language Pretraining \- arXiv, 访问时间为 五月 14, 2025， [https://arxiv.org/html/2405.00740v1](https://arxiv.org/html/2405.00740v1)  
57. Modeling Caption Diversity in Contrastive Vision-Language Pretraining \- GitHub, 访问时间为 五月 14, 2025， [https://raw.githubusercontent.com/mlresearch/v235/main/assets/lavoie24a/lavoie24a.pdf](https://raw.githubusercontent.com/mlresearch/v235/main/assets/lavoie24a/lavoie24a.pdf)  
58. Models \- Hugging Face, 访问时间为 五月 14, 2025， [https://huggingface.co/models?other=siglip](https://huggingface.co/models?other=siglip)  
59. arxiv.org, 访问时间为 五月 14, 2025， [https://arxiv.org/abs/2303.15343](https://arxiv.org/abs/2303.15343)  
60. arxiv.org, 访问时间为 五月 14, 2025， [https://arxiv.org/abs/2402.14786](https://arxiv.org/abs/2402.14786)  
61. arxiv.org, 访问时间为 五月 14, 2025， [https://arxiv.org/abs/2502.15682](https://arxiv.org/abs/2502.15682)  
62. How do you evaluate cross-modal retrieval performance in VLMs? \- Milvus, 访问时间为 五月 14, 2025， [https://milvus.io/ai-quick-reference/how-do-you-evaluate-crossmodal-retrieval-performance-in-vlms](https://milvus.io/ai-quick-reference/how-do-you-evaluate-crossmodal-retrieval-performance-in-vlms)  
63. Image–Text Cross-Modal Retrieval with Instance Contrastive Embedding \- MDPI, 访问时间为 五月 14, 2025， [https://www.mdpi.com/2079-9292/13/2/300](https://www.mdpi.com/2079-9292/13/2/300)  
64. Zero-shot Obejct Detection \- VISDRONE, 访问时间为 五月 14, 2025， [https://aiskyeye.com/zero-shot-obejct-detection/](https://aiskyeye.com/zero-shot-obejct-detection/)  
65. MS COCO Benchmark (Zero-shot Text-to-Image Retrieval) | Papers ..., 访问时间为 五月 14, 2025， [https://paperswithcode.com/sota/zero-shot-text-to-image-retrieval-on-ms-coco](https://paperswithcode.com/sota/zero-shot-text-to-image-retrieval-on-ms-coco)  
66. CLIP Zero-Shot retrieval results on the Flickr30K test set. We show... \- ResearchGate, 访问时间为 五月 14, 2025， [https://www.researchgate.net/figure/CLIP-Zero-Shot-retrieval-results-on-the-Flickr30K-test-set-We-show-retrieval-performance\_tbl2\_364443227](https://www.researchgate.net/figure/CLIP-Zero-Shot-retrieval-results-on-the-Flickr30K-test-set-We-show-retrieval-performance_tbl2_364443227)  
67. Architecture of the proposed zero-shot object detection framework. The... \- ResearchGate, 访问时间为 五月 14, 2025， [https://www.researchgate.net/figure/Architecture-of-the-proposed-zero-shot-object-detection-framework-The-core-idea-is-to\_fig3\_380788545](https://www.researchgate.net/figure/Architecture-of-the-proposed-zero-shot-object-detection-framework-The-core-idea-is-to_fig3_380788545)  
68. Self-Prompting Analogical Reasoning for UAV Object Detection, 访问时间为 五月 14, 2025， [https://ojs.aaai.org/index.php/AAAI/article/view/34026/36181](https://ojs.aaai.org/index.php/AAAI/article/view/34026/36181)  
69. UAVDT \- Dataset Ninja, 访问时间为 五月 14, 2025， [https://datasetninja.com/uavdt](https://datasetninja.com/uavdt)  
70. \[2502.09325\] A Benchmark for Crime Surveillance Video Analysis with Large Models \- arXiv, 访问时间为 五月 14, 2025， [https://arxiv.org/abs/2502.09325](https://arxiv.org/abs/2502.09325)  
71. Zero-Shot Action Recognition in Surveillance Videos \- arXiv, 访问时间为 五月 14, 2025， [https://arxiv.org/html/2410.21113v2](https://arxiv.org/html/2410.21113v2)  
72. Zero-shot Video Moment Retrieval via Off-the-shelf Multimodal Large Language Models, 访问时间为 五月 14, 2025， [https://arxiv.org/html/2501.07972v1](https://arxiv.org/html/2501.07972v1)  
73. CLIP-Enhance: Improving CLIP Zero-Shot Classification via von Mises-Fisher Clustering, 访问时间为 五月 14, 2025， [https://openreview.net/forum?id=KyeyEFPxJX](https://openreview.net/forum?id=KyeyEFPxJX)  
74. Developing Japanese CLIP Models Leveraging an Open-weight LLM for Large-scale Dataset Translation \- ACL Anthology, 访问时间为 五月 14, 2025， [https://aclanthology.org/2025.naacl-srw.15.pdf](https://aclanthology.org/2025.naacl-srw.15.pdf)  
75. Daily Papers \- Hugging Face, 访问时间为 五月 14, 2025， [https://huggingface.co/papers?q=CLIP-UP](https://huggingface.co/papers?q=CLIP-UP)  
76. zsxkib/jina-clip-v2 – Run with an API on Replicate, 访问时间为 五月 14, 2025， [https://replicate.com/zsxkib/jina-clip-v2/readme](https://replicate.com/zsxkib/jina-clip-v2/readme)  
77. laion/CLIP-ViT-B-32-laion2B-s34B-b79K · \[AUTOMATED\] Model Memory Requirements, 访问时间为 五月 14, 2025， [https://huggingface.co/laion/CLIP-ViT-B-32-laion2B-s34B-b79K/discussions/7](https://huggingface.co/laion/CLIP-ViT-B-32-laion2B-s34B-b79K/discussions/7)  
78. Built-In Zoo Models — FiftyOne 1.5.2 documentation \- Voxel51, 访问时间为 五月 14, 2025， [https://docs.voxel51.com/model\_zoo/models.html](https://docs.voxel51.com/model_zoo/models.html)  
79. jinaai/jina-clip-v1 · Hugging Face, 访问时间为 五月 14, 2025， [https://huggingface.co/jinaai/jina-clip-v1](https://huggingface.co/jinaai/jina-clip-v1)  
80. OpenCLIP \- open-clip-torch · PyPI, 访问时间为 五月 14, 2025， [https://pypi.org/project/open-clip-torch/2.0.2/](https://pypi.org/project/open-clip-torch/2.0.2/)  
81. OpenCLIP \- open-clip-torch · PyPI, 访问时间为 五月 14, 2025， [https://pypi.org/project/open-clip-torch/0.2.0/](https://pypi.org/project/open-clip-torch/0.2.0/)  
82. GPU vs CPU for inference : r/learnmachinelearning \- Reddit, 访问时间为 五月 14, 2025， [https://www.reddit.com/r/learnmachinelearning/comments/1aubc4u/gpu\_vs\_cpu\_for\_inference/](https://www.reddit.com/r/learnmachinelearning/comments/1aubc4u/gpu_vs_cpu_for_inference/)  
83. AI models on CPUs: accurate audio transcriptions without breaking the bank \- Mux, 访问时间为 五月 14, 2025， [https://www.mux.com/blog/how-to-leverage-ai-models-without-breaking-the-bank](https://www.mux.com/blog/how-to-leverage-ai-models-without-breaking-the-bank)  
84. Building High-Performance Image Search with OpenCLIP, Chroma, and Intel® Max GPUs, 访问时间为 五月 14, 2025， [https://community.intel.com/t5/Blogs/Tech-Innovation/Artificial-Intelligence-AI/Building-High-Performance-Image-Search-with-OpenCLIP-Chroma-and/post/1686081](https://community.intel.com/t5/Blogs/Tech-Innovation/Artificial-Intelligence-AI/Building-High-Performance-Image-Search-with-OpenCLIP-Chroma-and/post/1686081)  
85. Modeling Caption Diversity in Contrastive Vision-Language Pretraining \- arXiv, 访问时间为 五月 14, 2025， [https://arxiv.org/html/2405.00740v4](https://arxiv.org/html/2405.00740v4)  
86. AMD Instinct™ MI325X GPUs Produce Strong Performance in MLPerf Inference v5.0, 访问时间为 五月 14, 2025， [https://rocm.blogs.amd.com/artificial-intelligence/mi325x-accelerates-mlperf-inference/README.html](https://rocm.blogs.amd.com/artificial-intelligence/mi325x-accelerates-mlperf-inference/README.html)  
87. NVIDIA Data Center Deep Learning Product Performance AI Inference, 访问时间为 五月 14, 2025， [https://developer.nvidia.com/deep-learning-performance-training-inference/ai-inference](https://developer.nvidia.com/deep-learning-performance-training-inference/ai-inference)  
88. NVIDIA A100 Aces Throughput, Latency Results in Key Inference Benchmark for Financial Services Industry, 访问时间为 五月 14, 2025， [https://blogs.nvidia.com/blog/stac-ml-inference-gpu/](https://blogs.nvidia.com/blog/stac-ml-inference-gpu/)  
89. 4×A100 vs. 4×A6000 vLLM Benchmark for 72B LLM Inference \- Database Mart, 访问时间为 五月 14, 2025， [https://www.databasemart.com/blog/vllm-gpu-benchmark-a100-40gb-4](https://www.databasemart.com/blog/vllm-gpu-benchmark-a100-40gb-4)  
90. Benchmarking Nvidia RTX 5090 | Computer Vision Lab \- Nikolay Falaleev, 访问时间为 五月 14, 2025， [https://nikolasent.github.io/hardware/deeplearning/benchmark/2025/02/17/RTX5090-Benchmark.html](https://nikolasent.github.io/hardware/deeplearning/benchmark/2025/02/17/RTX5090-Benchmark.html)  
91. NVIDIA Blackwell Delivers World-Record DeepSeek-R1 Inference Performance, 访问时间为 五月 14, 2025， [https://developer.nvidia.com/blog/nvidia-blackwell-delivers-world-record-deepseek-r1-inference-performance/](https://developer.nvidia.com/blog/nvidia-blackwell-delivers-world-record-deepseek-r1-inference-performance/)  
92. openai/clip-vit-base-patch32 · \[AUTOMATED\] Model Memory Requirements \- Hugging Face, 访问时间为 五月 14, 2025， [https://huggingface.co/openai/clip-vit-base-patch32/discussions/11](https://huggingface.co/openai/clip-vit-base-patch32/discussions/11)  
93. jinaai/jina-clip-v2 · The issue of VRAM usage in image extraction \- Hugging Face, 访问时间为 五月 14, 2025， [https://huggingface.co/jinaai/jina-clip-v2/discussions/35](https://huggingface.co/jinaai/jina-clip-v2/discussions/35)  
94. The inference speed of MobileCLIP-S2's image encoder is slower than OpenCLIP's ViT-B-32-256 model on both CPU and GPU \- Hugging Face, 访问时间为 五月 14, 2025， [https://huggingface.co/apple/MobileCLIP-S2-OpenCLIP/discussions/3](https://huggingface.co/apple/MobileCLIP-S2-OpenCLIP/discussions/3)  
95. Benchmarking Models for Multi-modal Search \- Marqo, 访问时间为 五月 14, 2025， [https://www.marqo.ai/blog/benchmarking-models-for-multimodal-search](https://www.marqo.ai/blog/benchmarking-models-for-multimodal-search)  
96. ViT L 16 SigLIP 384 · Models \- Dataloop AI, 访问时间为 五月 14, 2025， [https://dataloop.ai/library/model/jonas-wells\_vit-l-16-siglip-384/](https://dataloop.ai/library/model/jonas-wells_vit-l-16-siglip-384/)  
97. ViT L 16 SigLIP 384 · Models \- Dataloop AI, 访问时间为 五月 14, 2025， [https://dataloop.ai/library/model/timm\_vit-l-16-siglip-384/](https://dataloop.ai/library/model/timm_vit-l-16-siglip-384/)  
98. ViT SO400M 14 SigLIP · Models \- Dataloop AI, 访问时间为 五月 14, 2025， [https://dataloop.ai/library/model/timm\_vit-so400m-14-siglip/](https://dataloop.ai/library/model/timm_vit-so400m-14-siglip/)  
99. Easily compute clip embeddings and build a clip retrieval system with them \- GitHub, 访问时间为 五月 14, 2025， [https://github.com/rom1504/clip-retrieval](https://github.com/rom1504/clip-retrieval)  
100. NVIDIA Deepstream vs NVIDIA Triton Inference Server \- Roboflow, 访问时间为 五月 14, 2025， [https://roboflow.com/compare-inference-servers/nvidia-deepstream-vs-nvidia-triton-inference-server](https://roboflow.com/compare-inference-servers/nvidia-deepstream-vs-nvidia-triton-inference-server)  
101. Optimization — NVIDIA Triton Inference Server \- NVIDIA Docs Hub, 访问时间为 五月 14, 2025， [https://docs.nvidia.com/deeplearning/triton-inference-server/user-guide/docs/user\_guide/optimization.html](https://docs.nvidia.com/deeplearning/triton-inference-server/user-guide/docs/user_guide/optimization.html)  
102. OpenVINO Inference Optimization for YOLO \- Ultralytics YOLO Docs, 访问时间为 五月 14, 2025， [https://docs.ultralytics.com/guides/optimizing-openvino-latency-vs-throughput-modes/](https://docs.ultralytics.com/guides/optimizing-openvino-latency-vs-throughput-modes/)  
103. SigLIP \- Hugging Face, 访问时间为 五月 14, 2025， [https://huggingface.co/docs/transformers/en/model\_doc/siglip](https://huggingface.co/docs/transformers/en/model_doc/siglip)  
104. Simplifying CLIP: Unleashing the Power of Large-Scale Models on Consumer-level Computers \- arXiv, 访问时间为 五月 14, 2025， [https://arxiv.org/html/2411.14789v1](https://arxiv.org/html/2411.14789v1)  
105. MobileCLIP: Fast Image-Text Models through Multi-Modal Reinforced Training \- ar5iv \- arXiv, 访问时间为 五月 14, 2025， [https://ar5iv.labs.arxiv.org/html/2311.17049](https://ar5iv.labs.arxiv.org/html/2311.17049)