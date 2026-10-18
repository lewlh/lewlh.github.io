---
title: RAG开源工具项目集
date: 2025-03-09 09:06:43
tags:
    - RAG
    - OpenSource
---


![OpenSourceCreateWorld.GenerateByQwen](/images/202503/OpenSourceCreateWorld.jpg)

大语言模型的快速发展以及性能的提升，为以前遥不可及的想法/功能提供了可能，同时很多都被实现出来，惊艳了世界。开源项目为世界提供了纷繁复杂的工具，极大加速了创新。对于个人开发者以及小团队，在大语言模型这个浪潮下的生存土壤，我认为就是微创新+快速迭代，不断尝试寻找机会，找到需求和买家。一些微创新和新想法来自于新工具/新事物的出现，快速组合，因此在开源世界上及时发现这些新项目，尤为重要。本文将长期更新，积累我在互联网世界中发现的好玩的/有意思的/性价比高的开源项目，同时也分享给大家。

<!-- more -->

**********

## RAG框架

+ [MaxKB](https://github.com/1Panel-dev/MaxKB/blob/main/README_CN.md)是一款基于大语言模型和 RAG 的开源知识库问答系统，广泛应用于智能客服、企业内部知识库、学术研究与教育等场景。
  + 开箱即用：支持直接上传文档 / 自动爬取在线文档，支持文本自动拆分、向量化和 RAG（检索增强生成），有效减少大模型幻觉，智能问答交互体验好；
  + 模型中立：支持对接各种大模型，包括本地私有大模型（DeepSeek R1 / Llama 3 / Qwen 2 等）、国内公共大模型（通义千问 / 腾讯混元 / 字节豆包 / 百度千帆 / 智谱 AI / Kimi 等）和国外公共大模型（OpenAI / Claude / Gemini 等）；
  + 灵活编排：内置强大的工作流引擎和函数库，支持编排 AI 工作过程，满足复杂业务场景下的需求；
  + 无缝嵌入：支持零编码快速嵌入到第三方业务系统，让已有系统快速拥有智能问答能力，提高用户满意度。
  + <iframe src="//player.bilibili.com/player.html?isOutside=true&aid=113349706646685&bvid=BV18JypYeEkj&cid=26408061017&p=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"></iframe>
+ [PIKE-RAG](https://github.com/microsoft/PIKE-RAG)系统是一种检索增强生成（RAG）框架，旨在解决传统RAG系统在处理复杂、领域特定工业应用时的局限性。
  + 它包括文档解析、知识提取、存储、检索、组织、推理和任务分解/协调等多个模块，相比之下，通用RAG系统通常只包含检索器和生成器两个主要部分。这种模块化设计让PIKE-RAG更灵活，能适应工业领域的多样化需求。
  + 它使用上下文感知分割和多粒度知识提取技术，特别适合处理专业术语和领域特定知识。通用RAG系统更多依赖简单的检索方法，如关键词匹配或语义相似性，可能会在处理复杂领域知识时表现不佳。
  + 它能生成推理逻辑路径，指导语言模型产生准确回答，并支持将复杂查询分解为小任务，适合需要多步推理的场景。通用RAG系统通常不具备这些功能，更多是直接基于检索内容生成回答。
  + 它针对制造业、采矿和制药等工业领域进行了优化，处理专业术语和结构化数据的能力更强，这一点在通用RAG中不常见。
+ [Vanna](https://github.com/vanna-ai/vanna) 是一个 MIT 许可的开源 Python RAG（检索增强生成）框架，用于 SQL 生成和相关功能。Vanna 的工作分为两个简单的步骤 - 在您的数据上训练 RAG“模型”，然后提出问题，这些问题将返回可设置为在您的数据库上自动运行的 SQL 查询。
+ [PageIndex](https://github.com/VectifyAI/PageIndex) 是一个由 Vectify AI 开发的开源文档索引系统，专注于为基于推理的 RAG（Retrieval-Augmented Generation，检索增强生成） 提供支持。它通过将长文档（例如 PDF 文件）转化为语义树结构（hierarchical tree structure），优化大语言模型（LLM）处理复杂文档的能力。项目既可以自托管，也可以通过 Vectify AI 提供的云服务使用。核心目标是解决长文档（如财务报告、监管文件、学术教材、法律或技术手册）超出 LLM 上下文长度限制的问题，通过结构化索引提升文档检索和推理的效率与精准度。
+ [RAGFlow](https://github.com/infiniflow/ragflow) 是一个结合检索增强生成（Retrieval-Augmented Generation）和深度文档理解的开源框架，专注于从复杂格式的非结构化数据（如 PDF、Word、Excel、图像、网页等）中提取知识，并结合大语言模型（LLM）生成准确、可靠的回答。其核心目标是：
  + 解决复杂文档处理难题：通过深度文档理解技术（如布局分析、表格结构识别、OCR 等），从格式复杂的文档中提取关键信息。
  + 提供可追溯的问答：生成答案时附带引用的原始数据来源，减少大语言模型的“幻觉”（hallucination）问题。
  + 支持多模态数据：不仅处理文本，还能解析图像、表格、网页等多样化数据。
  + 适配多种规模业务：提供灵活的模板和配置，适合个人开发者到大型企业的需求。
+ [deepwiki-open](https://github.com/AsyncFuncAI/deepwiki-open) 是一个开源的、AI驱动的 Wiki 生成工具，主要用于为 GitHub、GitLab 和 Bitbucket 上的代码仓库自动生成结构化的文档（Wiki）。它通过分析仓库的代码结构、README 文件和配置信息，生成类似 Wikipedia 风格的文档，并提供交互式功能，如基于代码的问答（Retrieval Augmented Generation, RAG）。该项目旨在解决开发者在面对复杂或文档不全的代码仓库时，难以快速理解代码结构和功能的问题。

## AI-Agent

+ [OpenManus](https://github.com/mannaandpoem/OpenManus/blob/main/README_zh.md)是一个由 MetaGPT 团队开发的开源项目，旨在复刻并优化 Manus 的核心功能。Manus 是一款由中国团队开发的新型 AI 助手（AI Agent），以其强大的自主任务执行能力而闻名，例如规划旅行、分析股票、生成代码等，但它目前需要邀请码才能使用，且访问门槛较高。OpenManus 的目标是将类似的功能带入开源社区，提供一个无需邀请码、可本地部署的智能体解决方案，让更多人能够自由使用和定制。
+ [Index](https://github.com/lmnr-ai/index) 是开源自动化浏览器智能体，用于在网络上自主执行复杂任务。
  + 提供 API 和可视化操作 UI 界面，也支持完全自托管部署使用
  + 能执行复杂的网页任务，如数据收集、表单填写和内容分析
  + 支持自定义浏览器窗口大小和远程 CDP 连接
+ [DroidRun](https://github.com/droidrun/droidrun) 是一个强大的框架，用于通过 LLM 代理控制 Android 设备。它允许您使用自然语言命令自动化 Android 设备交互。
  + 使用自然语言命令控制 Android 设备
  + 支持多个 LLM 提供商（OpenAI、Anthropic、Gemini）
  + 易于使用的 CLI
  + 用于自定义自动化的可扩展 Python API
  + 屏幕截图分析，直观了解设备
+ [CodeScientist](https://github.com/allenai/codescientist) 是一个集成了创意生成、实验设计、代码实现、实验运行、结果分析和报告生成的系统，专注于通过 Python 代码表达的科学实验。它的核心目标是模拟科学发现的完整流程，减少人工干预，提高研究效率。项目特别强调以下功能：
  + 自动化实验设计与执行：从科学文献和代码片段中生成实验创意，自动构建、运行和调试实验代码。
  + 模块化与可扩展性：通过“codeblocks”（代码块）机制，允许用户添加新的功能模块，增强系统灵活性。
  + 结果分析与报告：自动生成实验报告，并通过多次实验运行进行元分析（meta-analysis），提高结果可靠性。
+ [Suna](https://github.com/kortix-ai/suna) 是一个由 Kortix AI Corp 开发的开源通用人工智能代理（Generalist AI Agent）平台，旨在通过自然语言对话帮助用户完成现实世界的复杂任务。它定位为一个数字助手，能够处理研究、数据分析、自动化工作流等任务，强调自主性和多功能性。Suna 的设计目标是通过直观的交互界面和强大的工具集，让用户能够通过简单的对话实现复杂任务的自动化。它集成了浏览器自动化、文件管理、数据分析、API 集成等功能，适合研究、商业分析、内容生成等多种场景。项目采用现代技术栈（FastAPI、TypeScript），支持自托管，完全开源，吸引了大量开发者和企业的关注。如果你需要一个灵活、可定制的 AI 助手来处理复杂任务，Suna 是一个值得探索的选择。
+ [WeClone](https://github.com/xming521/WeClone) 是一个开源项目，旨在通过微信聊天记录和语音消息，结合大语言模型（LLM）和语音合成技术，打造个性化的数字分身。具体功能包括：
  + 聊天记录驱动的语言模型微调：利用用户的微信聊天记录对大语言模型进行微调，使其模仿用户的语言风格、表达习惯和语气。
  + 高质量语音克隆：通过微信语音消息和 0.5B 参数的语音模型，仅需 5 秒语音样本即可生成高达 95% 相似度的声音克隆，保留语调和情感。
  + 绑定聊天机器人：将微调后的模型和克隆语音绑定到微信机器人（如通过 AstrBot 支持的微信、QQ 等平台），实现自动回复文字和语音，模拟用户本人进行实时交互。
  + 数据隐私保护：默认过滤敏感信息（如手机号、身份证号、邮箱、网址），并支持自定义禁用词库，保护用户隐私。
+ [Cua](https://github.com/trycua/cua) 是一个强大的开源项目，结合 高性能虚拟化 和 AI 代理，让 AI 能在安全的虚拟环境中操作桌面应用，特别适合 Apple Silicon 用户。它通过 Lume 提供虚拟机管理，通过 cua-agent 和 cua-computer 实现 AI 控制，适用于自动化办公、开发、安全测试等场景。项目文档完善，社区活跃，易于上手和扩展。支持的任务：
  + 浏览网页（如搜索 GitHub 仓库）。
  + 自动化办公（处理文档、填写表格、发送邮件）。
  + 软件开发（编写代码、调试、打开 IDE 如 VS Code）。
  + 复杂工作流（如同时操作浏览器、终端和编辑器）。

## 内容整合

无论是网页、代码库或者是文档，我们都需要将这些内容整合为大语言模型的上下文，我们需要用到一些工具自动化处理，避免手动整理。

+ [OneFileLLM: Efficient Data Aggregation for LLM Ingestion](https://github.com/jimmc414/onefilellm) 它旨在简化大型语言模型 (LLM) 中信息密集型提示的创建。它聚合并预处理来自各种来源的数据，将它们编译成一个文本文件，该文件会自动复制到剪贴板以便快速使用。
  + 根据提供的路径、URL 或标识符自动检测源类型
  + 支持本地文件和/或目录、GitHub 存储库、GitHub 拉取请求、GitHub 问题、ArXiv 的学术论文、YouTube 成绩单、网页文档、通过 DOI 或 PMID 托管的 Sci-Hub 论文
  + 处理多种文件格式，包括 Jupyter Notebooks (.ipynb) 和 PDF
  + Web 爬取功能，从链接页面中提取指定深度的内容
  + 与 Sci-Hub 集成，使用 DOI 或 PMID 自动下载研究论文
  + 文本预处理，包括压缩和未压缩输出、停用词删除和小写转换
  + 自动将未压缩的文本复制到剪贴板，以便轻松粘贴到 LLM 中
  + 压缩和未压缩输出的令牌计数报告
  + XML 封装输出以提高 LLM 性能
+ [MarkItDown](https://github.com/microsoft/markitdown) 是一个轻量级的 Python 实用程序，用于将各种文件转换为 Markdown，以便用于 LLM 和相关的文本分析流程。
  + [支持 MCP 协议](https://github.com/microsoft/markitdown/tree/main/packages/markitdown-mcp)；
  + 支持微软办公软件全家桶；
  + 支持图像、音频、视频等多种格式；
  + 广泛支持各种文本格式；
+ [Tutorial-Codebase-Knowledge](https://github.com/The-Pocket/Tutorial-Codebase-Knowledge) 它抓取 GitHub 代码库并从代码中构建知识库。它分析整个代码库以识别核心抽象及其交互方式，并将复杂的代码转换为具有清晰可视化效果的初学者友好型教程。

## 文档识别

+ [olmOCR](https://github.com/allenai/olmocr) 是一个开源的光学字符识别（OCR）项目，主要功能是将PDF和其他文档转换为纯文本，同时保留原始文档的阅读顺序。以下是关于olmOCR的一些关键信息：
  + 能够处理复杂的文档布局，包括表格、数学公式和手写内容。
  + 旨在提高PDF文档转换为可编辑文本的效率和准确性。
  + 利用视觉语言模型（VLMs）解析和线性化复杂的PDF文档。
  + 支持分布式多节点解析数百万份PDF文档。
+ [SmolDocling-256M-preview](https://huggingface.co/ds4sd/SmolDocling-256M-preview) 是一个轻量级文档 OCR 模型。该模型以仅 256MB 的体积、0.35 秒/页 的超快处理速度，以及 <500MB VRAM 的极低显存需求，成为 RAG（检索增强生成）和端侧文档处理领域的颠覆性工具。其性能宣称超越同类模型 27 倍，并在文档转换任务中达到 SOTA 水平。
  + [消费级显卡的 OCR 革命：256M 超轻量模型 SmolDocling 开源解析](https://zhuanlan.zhihu.com/p/1885392121441277846)
+ [Docling](https://github.com/docling-project/docling) 简化了文档处理，解析各种格式（包括高级 PDF 理解），并提供与 gen AI 生态系统的无缝集成。
  + 🗂️ 解析多种文档格式，包括 PDF、DOCX、XLSX、HTML、图像等
  + 📑 高级 PDF 理解，包括页面布局、阅读顺序、表格结构、代码、公式、图像分类等
  + 🧬 统一、富有表现力的DoclingDocument表现格式
  + ↪️ 各种导出格式和选项，包括 Markdown、HTML 和无损 JSON
  + 🔒 针对敏感数据和隔离环境的本地执行能力
  + 🤖 即插即用集成，包括 LangChain、LlamaIndex、Crew AI 和用于代理 AI 的 Haystack
  + 🔍 广泛支持扫描的 PDF 和图像的 OCR
  + 🥚 支持视觉语言模型（SmolDocling）🆕
  + 💻 简单方便的 CLI
+ [PDF-Craft](https://github.com/oomol-lab/pdf-craft) 可以将 PDF 文件转化为各种其他格式。该项目将专注于扫描书籍的 PDF 文件的处理。本项目可将 PDF 一页一页读出，并使用 DocLayout-YOLO 混合我写的一个算法，将书页中的正文提取出来，并过滤掉页眉、页脚、脚注、页码等元素。在跨页过程中，会使用算法判断以妥善处理前后文跨页顺接问题，最终生成语义通顺的文本。书页会使用 OnnxOCR 进行文本识别。并使用 layoutreader 来确定符合人类习惯的阅读顺序。
+ [zerox](https://github.com/getomni-ai/zerox) 基于视觉模型（主要是 GPT-4o-mini 等多模态模型）进行零样本（zero-shot）OCR 和文档内容提取，将复杂文档（如 PDF、DOCX、图片）转换为结构化的 Markdown 格式。
  + 零样本识别: 无需预训练或用户提供样本，直接处理各类文档。
  + 多格式支持: 支持 PDF、DOCX、图片等格式，特别擅长处理复杂布局（表格、图表等）。
  + 开源灵活: 提供 Node.js 和 Python 包，开发者可自由定制和集成。
  + 高精度: 利用先进的视觉模型（如 GPT-4o-mini、Gemini、Claude 等）实现精准的文本提取。
  + API 集成: 提供 API 接口，便于自动化和批量处理。
+ [OCRmyPDF](https://github.com/ocrmypdf/OCRmyPDF) 是一个开源的命令行工具和 Python 库，旨在为扫描的 PDF 文件添加光学字符识别（OCR）文本层，使其内容可搜索、可选择和可复制。
+ [MarkPDFdown](https://github.com/MarkPDFdown/markpdfdown) 是一个基于多模态大语言模型（Multimodal Large Language Model）的开源工具，旨在将 PDF 文件转换为 Markdown 格式，同时尽可能保留文档的结构和格式。它通过 AI 技术（依赖 OpenAI 的 API）实现高质量的文档内容理解和转换，适用于需要将 PDF 文档转为可编辑、可分享的 Markdown 格式的场景。
  + PDF转Markdown：支持任意PDF文档的格式转换
  + 图片转Markdown：支持JPG/PNG/BMP图片内容转Markdown
  + 多模态理解：利用AI理解文档结构和内容
  + 格式保留：完整保留标题、列表、表格等排版元素
  + 模型定制：支持自定义AI模型参数配置
+ [No OCR](https://github.com/kyryl-opens-ml/no-ocr) 是一个开源项目，旨在提供一种高效的 PDF 文档搜索和信息提取解决方案，特别针对 视觉复杂性高的文档（如包含表格、图表、图形、复杂排版的 PDF）。与传统的 OCR（光学字符识别）技术不同，No-OCR 不依赖 OCR 技术，而是利用 开源的机器学习模型（主要是大型语言模型 LLMs）来处理和理解文档内容，从而实现更高效、更精准的搜索和信息提取。

## 文字转音频

+ [MegaTTS3](https://github.com/bytedance/MegaTTS3) 是由 ByteDance（字节跳动） 与 浙江大学 合作开发的一款 开源文本到语音（Text-to-Speech, TTS） 模型，专注于生成 高质量的中文和英文语音。其核心特点是 轻量高效（仅 0.45 亿参数），支持 语音克隆、中英文混合语音生成 和 口音强度控制，适用于学术研究、内容创作和语音交互等场景。
+ [Spark-TTS](https://github.com/SparkAudio/Spark-TTS) 是一个基于大型语言模型（LLM）的文本转语音（Text-to-Speech, TTS）系统，旨在提供高效、自然且高质量的语音合成。它基于 Qwen2.5 模型，通过创新的 BiCodec 语音编解码器实现语音生成，特别擅长零样本语音克隆（zero-shot voice cloning）和细粒度语音控制,支持中英文双语。它通过开源代码、模型和 VoxBox 数据集推动 TTS 研究，但受限于 16kHz 音质和非商业许可。该项目适用于学术研究、教育以及合法的个性化语音合成场景（如辅助技术、语言研究等）。

## 音频转文字

+ [SoftWhisper](https://github.com/NullMagic2/SoftWhisper)基于 Whisper.cpp 实现的高性能音频转文字的工具，官方宣称可以在大约 2-3 分钟内转录 2 小时的音频。

## 音乐创作

+ [DiffRhythm](https://aslp-lab.github.io/DiffRhythm.github.io/)是一个能够创作完整歌曲的开源基于扩散的音乐生成模型，由西北工业大学音频语音与语言处理研究组开发。

## 声音克隆

+ [OpenVoice](https://github.com/myshell-ai/OpenVoice) 这是一种多功能的即时语音克隆方法，只需参考说话者的一小段音频片段即可复制其声音并生成多种语言的语音。OpenVoice 除了能够复制参考说话者的音色外，还能对语音风格进行精细控制，包括情绪、重音、节奏、停顿和语调。对于未包含在海量说话者训练集中的语言，OpenVoice 还实现了零样本跨语言语音克隆。OpenVoice 的计算效率也很高，其成本比市面上性能更差的 API 低数十倍。
+ [Realtime-Voice-Clone-Chinese](https://github.com/hubin858130/Realtime-Voice-Clone-Chinese) 基于 Real-Time-Voice-Cloning 项目的中文分支，专为中文语音克隆优化。
+ [Bark-Voice-Cloning](https://github.com/KevinWang676/Bark-Voice-Cloning) 基于 Bark 模型的中文语音克隆项目，采用 SambertHifigan 技术路径。
+ [IndexTTS](https://github.com/index-tts/index-tts) 是一个基于 GPT 风格的文本转语音 (TTS) 模型，主要基于 XTTS 和 Tortoise 算法。它能够通过拼音纠正汉字发音，并通过标点符号控制任意位置的停顿。我们增强了系统的多个模块，包括改进说话人条件特征表示，并集成 BigVGAN2 以优化音频质量。我们的系统基于数万小时的数据进行训练，达到了最佳性能，超越了目前流行的 TTS 系统，例如 XTTS、CosyVoice2、Fish-Speech 和 F5-TTS。

## MCP 服务

+ [GitMCP](https://github.com/idosal/git-mcp) 一款开源的 MCP 服务器，它能为任何 GitHub 项目生成详细使用教程文档。
+ [mcp-server-browserbase](https://github.com/browserbase/mcp-server-browserbase) 是一个基于 Model Context Protocol (MCP) 的服务器实现，旨在让大型语言模型 (LLMs) 通过 Browserbase 和 Stagehand 控制云端浏览器，实现自动化网页交互。MCP 是一种开放协议，用于连接 LLM 应用程序与外部数据源和工具，这个项目则是其具体应用之一，专注于浏览器自动化。简单来说，这个项目允许 AI（如 Claude 或其他支持 MCP 的 LLM）通过标准化的接口与网页交互，执行诸如导航、点击、填写表单、截图、执行 JavaScript 等操作，运行在云端浏览器环境中。
+ [ghidraMCP](https://github.com/LaurieWired/GhidraMCP) 是一个为 Ghidra（由 NSA 开发的一个开源逆向工程工具）设计的 Model Context Protocol (MCP) 服务器。它的核心目的是通过 MCP 协议，将 Ghidra 的逆向工程功能暴露给大型语言模型（LLMs，如 Claude、Gemini 或本地模型），从而让 AI 能够自动化地进行软件逆向工程、恶意软件分析和漏洞发现等任务。简单来说，GhidraMCP 充当了 Ghidra 和 AI 模型之间的桥梁，允许 AI 通过自然语言指令或自动化脚本调用 Ghidra 的功能，完成复杂的二进制分析任务。
+ [deepwiki-mcp](https://github.com/regenrek/deepwiki-mcp) 是一个基于 Model Context Protocol (MCP) 的服务器工具，旨在通过爬取 <deepwiki.com> 上的内容，将其转换为 Markdown 格式，供代码编辑器（如 Cursor）或其他支持 MCP 的客户端使用。它主要服务于开发者，帮助他们快速获取和整合 DeepWiki 上的知识内容，提升编码和研究效率。DeepWiki 是一个以 AI 为核心的知识平台，专注于技术内容的聚合、结构化呈现和工具集成。它通过 MCP 协议与开发环境对接，帮助开发者高效获取和利用知识资源。类似于一个“技术维基”，但更智能、更专注于开发场景。
+ [excel-mcp-server](https://github.com/haris-musa/excel-mcp-server) 是一个基于 Model Context Protocol (MCP) 的服务器项目，旨在通过 Python 和 OpenPyXL 库提供无需安装 Microsoft Excel 的 Excel 文件操作功能。它允许用户通过 AI 代理（例如支持 MCP 协议的 LLM 客户端，如 Claude、Cursor 等）以自然语言或编程方式对 Excel 文件进行创建、读取、修改、格式化等操作。项目的核心目标是提供强大的 Excel 文件处理能力，适用于自动化数据处理、分析和报表生成等场景。

## 文本翻译

+ [MTranServer](https://github.com/xxnuo/MTranServer) 一个超低资源消耗超快的离线翻译服务器，英译中模型仅需 300MiB 内存即可运行，无需显卡。单个请求平均响应时间 50ms。支持全世界主要语言的翻译。翻译质量与 Google 翻译相当。注意本模型专注于速度和多种设备私有部署，所以翻译质量肯定是不如大模型翻译的效果。
