# Lewlh's blog

[Lewlh 的个人博客](https://lewlh.github.io) 的源码，使用 Hexo + NexT 主题。

- 源码仓库：本仓库（`lewlh/lewlh.github.io`）
- 构建/发布：GitHub Actions（`.github/workflows/pages.yml`），推送到 `master` 即自动构建并用 GitHub 官方 Pages 动作发布。

## 环境要求

- Node.js 22（见 `.nvmrc`）

```bash
npm ci
```

## 日常维护

### 新建一篇博客文章

在 `source/_posts` 下新建 md 文件：

```bash
npx hexo new 文件名
```

编辑生成的 `source/_posts/文件名.md`，补齐 front-matter（`title`、`date`、`tags`）。

### 本地预览

```bash
npx hexo clean && npx hexo server   # http://localhost:4000
```

### 发布

提交并推送到 `master`：

```bash
git add -A && git commit -m "..." && git push
```

推送后 GitHub Actions 会自动构建并发布，无需再运行 `hexo deploy`。

## 主要配置

- `_config.yml`：站点与插件配置
- `_config.next.yml`：NexT 主题覆盖配置
- `themes/next`、`source/lib/pdf`：git 子模块（克隆后执行 `git submodule update --init --recursive`）

## 历史与回滚

- `backup/pages-output-2026-10`：迁移前的生成产物（旧站点内容），用于回滚。
- 原 Hexo 源码仓库 `lewlh/hexo` 作为备份保留。
