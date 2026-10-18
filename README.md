# Lewlh's blog

个人博客 <https://lewlh.github.io> 的源码仓库（Hexo + NexT 主题）。

## 架构

| 环节 | 说明 |
| --- | --- |
| 源码 | 本仓库 `lewlh/lewlh.github.io` 的 `master` 分支 |
| 生成 | GitHub Actions（`.github/workflows/pages.yml`）执行 `npm ci` + `hexo generate` |
| 发布 | GitHub 官方 Pages 动作发布，**推送到 `master` 即自动上线** |
| 主题 | `themes/next`（子模块，NexT v8.29.0） |
| PDF 组件 | `source/lib/pdf`（子模块，theme-next-pdf） |

> 不再需要 `hexo deploy`、Docker 或本地部署脚本，也不要再使用「Deploy from a branch」方式发布。

## 环境准备

需要 Node.js 22（见 `.nvmrc`）。

```bash
git clone git@github.com:lewlh/lewlh.github.io.git
cd lewlh.github.io

# 初始化主题与 PDF 子模块（必须）
git submodule update --init --recursive

# 安装依赖
npm ci
```

## 本地预览

```bash
npx hexo clean
npx hexo server          # 打开 http://localhost:4000
```

也可以只生成静态文件，产物在 `public/`：

```bash
npx hexo clean && npx hexo generate
```

## 新增文章

```bash
npx hexo new 我的新文章      # 生成 source/_posts/我的新文章.md
```

也可以直接在 `source/_posts/` 下新建 `.md` 文件。文件头部 front-matter 示例：

```markdown
---
title: 我的新文章
date: 2026-10-18 14:00:00
tags:
  - Hexo
  - 运维
categories:
  - 技术
---

这里是正文。

<!-- more -->

在 `<!-- more -->` 之后的内容不会出现在首页摘要里。
```

- `tags`/`categories` 会自动生成对应的标签页、分类页。
- 草稿：`npx hexo new draft 草稿名`，草稿不会发布；完成后 `npx hexo publish 草稿名`。

## 图片与附件

- 把图片放进 `source/images/`（可按年月建子目录），正文里用**站内绝对路径**引用：

  ```markdown
  ![说明](/images/202510/example.png)
  ```

- 较大的 PDF 放到 `source/pdfs/`，正文里可链接或使用主题的 PDF 标签：

  ```markdown
  {% pdf /pdfs/example.pdf %}
  ```

## 写作增强

- **数学公式（KaTeX）**：行内用 `$...$`，独立成行用 `$$...$$`。
- **流程图（Mermaid）**：使用带 `mermaid` 语言的代码块：

  ````markdown
  ```mermaid
  graph TD; A-->B;
  ```
  ````

- 代码高亮、脚注、上下标等 markdown-it 能力均已启用。

## 发布

改完文章后，提交并推送到 `master` 即可，Actions 会自动构建并上线：

```bash
git add -A
git commit -m "post: 新增文章《xxx》"
git push
```

约 1–2 分钟后访问 <https://lewlh.github.io> 即可看到更新（浏览器可能需 `Ctrl+Shift+R` 强制刷新）。

## 查看构建状态 / 失败排查

- 打开仓库的 **Actions** 页，查看 `Build and Deploy to GitHub Pages` 最近一次运行。
- 常见失败原因：
  - `npm ci` 失败：`package.json` 与 `package-lock.json` 不一致，本地执行 `npm install` 后提交更新后的 lock 文件。
  - `hexo generate` 失败：文章 front-matter 或 markdown 语法有问题，看日志定位到具体文件。
  - `Deploy to GitHub Pages` 被拒：到 **Settings → Environments → github-pages** 确认允许 `master` 分支部署。

## 配置说明

| 文件 | 作用 |
| --- | --- |
| `_config.yml` | 站点信息、URL、插件、markdown 等 |
| `_config.next.yml` | NexT 主题配置（配色、菜单、评论、统计等） |
| `.github/workflows/pages.yml` | 构建与部署流水线 |

## 更新主题 / 子模块

```bash
cd themes/next            # 或 source/lib/pdf
git fetch --tags
git checkout v8.x.x       # 选择目标版本
cd ../..
git add themes/next
git commit -m "chore: 升级 NexT 主题"
git push
```

主题升级后请对照新版 `themes/next/_config.yml` 检查 `_config.next.yml` 中的配置项是否有增删。

## 备份与回滚

- `backup/pages-output-2026-10`：迁移前的旧站点产物。
- 原 Hexo 源码仓库 `lewlh/hexo`（含 `backup/pre-upgrade-2026-10`、`chore/upgrade-hexo8`）作为历史备份保留。

回滚到迁移前状态：

```bash
git push --force origin backup/pages-output-2026-10:master
# 并把 Settings → Pages → Source 改回 "Deploy from a branch / master"
```
