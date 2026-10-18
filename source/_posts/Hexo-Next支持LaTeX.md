---
title: Hexo+Next支持LaTeX
date: 2020-08-08 15:59:08
mathjax: true
tags:
    - hexo
    - next
    - LaTeX
    - mathjax
    - pandoc
---

![LaTeX](/images/LaTeX_project_logo_bird.svg)

有朋友咨询问 Hexo 是否支持 [LaTeX](https://www.latex-project.org/) 数学表达式，开始我以为是支持的，后来发现竟然默认是不支持，由于 hexo 默认支持 markdown 语法，该语法与 LaTeX 语法有一些冲突，大部分用户其实不大需要 LaTeX，所以一直没有默认支持。网络上一搜这个主题，发现有很多解决方案。我想不如趁热打铁，让自己的博客也支持一下，顺便把自己的经验分享给大家。

<!-- more -->

## 现状

我查看了一下自己 hexo 的配置，发现 hexo 默认使用的页面渲染器是`hexo-renderer-marked`,这个渲染器是无法解析 LaTeX 的表达式的。

```json
{
  "name": "hexo-site",
  "version": "0.0.0",
  "private": true,
  "scripts": {
    "build": "hexo generate",
    "clean": "hexo clean",
    "deploy": "hexo deploy",
    "server": "hexo server"
  },
  "hexo": {
    "version": "4.2.1"
  },
  "dependencies": {
    "gitalk": "^1.6.2",
    "hexo": "^4.2.1",
    "hexo-deployer-git": "^2.1.0",
    "hexo-generator-archive": "^1.0.0",
    "hexo-generator-category": "^1.0.0",
    "hexo-generator-index": "^1.0.0",
    "hexo-generator-searchdb": "^1.3.0",
    "hexo-generator-sitemap": "^2.0.0",
    "hexo-generator-tag": "^1.0.0",
    "hexo-renderer-ejs": "^1.0.0",
    "hexo-renderer-marked": "^2.0.0",
    "hexo-renderer-stylus": "^1.1.0",
    "hexo-server": "^1.0.0",
    "hexo-word-counter": "0.0.1"
  }
}
```

在网络上搜了一圈，看了其他博客的相关文章，发现 Next 主题在 github 上有专门的文档给出 Next 主题支持 Math Equations 的[方案](https://github.com/theme-next/hexo-theme-next/blob/master/docs/MATH.md)。

## 我的方案

在寻找方案的过程中，我找到一个新的插件 `hexo-filter-mathjax`，用于Hexo的服务器端MathJax Renderer插件。我感觉只需要以下组件，就可以实现对 LaTeX 的支持：

+ [hexo-filter-mathjax](https://github.com/next-theme/hexo-filter-mathjax)
+ [hexo-renderer-pandoc](https://github.com/wzpan/hexo-renderer-pandoc)
+ [pandoc](https://github.com/jgm/pandoc)

### 安装 hexo-renderer-pandoc

需要先卸载当前 Hexo 使用的渲染器，笔者当前的渲染器是 hexo-renderer-marked，因此需要先卸载，再安装 hexo-renderer-pandoc：

```bash
# 在 Hexo 项目目录下执行
npm uninstall hexo-renderer-marked
npm install hexo-renderer-pandoc --save
```

### 安装 hexo-filter-mathjax

```bash
# 在 Hexo 项目目录下执行
npm install hexo-filter-mathjax --save
```

### 安装 pandoc

官方提供[安装指南](https://github.com/jgm/pandoc/blob/master/INSTALL.md)，按照提示安装即可。笔者使用 MacOS，尝试使用 brew 安装一直都不成功，最后直接去 [github](https://github.com/jgm/pandoc/releases) 下载 pandoc 安装包直接安装。

```bash
> ~ pandoc -v
pandoc 2.10.1
Compiled with pandoc-types 1.21, texmath 0.12.0.2, skylighting 0.8.5
Default user data directory: /Users/liulonghao/.local/share/pandoc or /Users/liulonghao/.pandoc
Copyright (C) 2006-2020 John MacFarlane
Web:  https://pandoc.org
This is free software; see the source for copying conditions.
There is no warranty, not even for merchantability or fitness
for a particular purpose.
```

### 修改配置

修改 hexo 的配置文件 `_config.yml`,首先启用 mathjax：

```yml
  math:
    mathjax:
      enable: true
```

添加 hexo-filter-mathjax 的配置：

```yml
# hexo-filter-mathjax
# https://github.com/next-theme/hexo-filter-mathjax
mathjax:
  tags: none # or 'ams' or 'all'
  single_dollars: true # enable single dollar signs as in-line math delimiters
  cjk_width: 0.9 # relative CJK char width
  normal_width: 0.6 # relative normal (monospace) width
  append_css: true # add CSS to every page
  every_page: false # if true, every page will be rendered by mathjax regardless the `mathjax` setting in Front-matter of each article
```

### 在文档中使用

使用 hexo 新建一个页面：

```bash
hexo new Hexo+Next支持LaTeX
```

编辑 `Hexo+Next支持LaTeX.md`,设置参数 `mathjax: true`

```md
---
title: Hexo+Next支持LaTeX
date: 2020-08-08 15:59:08
mathjax: true
tags:
    - hexo
    - next
    - LaTeX
    - mathjax
    - pandoc
---
```

在文档中输入 LaTeX 相关表达式

```md
-$ \epsilon_0 $
+$\epsilon_0$
-$ \frac{\partial}{\partial t} $
+$\frac{\partial}{\partial t}$
```

渲染页面

```bash
# 本地预览
hexo s

# 发布到生产环境
hexo deploy
```

## Sample

### 普通示例

```bash
$$-\epsilon_0 $$
$$+\epsilon_0 $$
$$-\frac{\partial}{\partial t}$$
$$+\frac{\partial}{\partial t}$$
```

$$-\epsilon_0 $$
$$+\epsilon_0 $$
$$-\frac{\partial}{\partial t}$$
$$+\frac{\partial}{\partial t}$$

$$\frac{1024}{15}\times\frac{(15000+15000)}{5000}=409.6s$$

$$\frac{256}{6700000}\times\frac{13846}{0.0005}=1058s$$

$$RI=\frac{PagesPerMBofDRAM}{PricePerMBofDRAM}\times\frac{PricePerDiskDrive}{AccessesPerSecondPerDisk}$$

```bash
$$
i\hbar\frac{\partial}{\partial t}\psi=-\frac{\hbar^2}{2m}\nabla^2\psi+V\psi
$$
```

$$
i\hbar\frac{\partial}{\partial t}\psi=-\frac{\hbar^2}{2m}\nabla^2\psi+V\psi
$$

### 定界符（括号等）

各种括号用 (), [], \{\}, \langle\rangle 等命令表示；注意花括号通常用来输入命令和环境的参数，所以在数学公式中它们前面要加 \。因为 LaTeX 中 | 和 \| 的应用过于随意，amsmath 宏包推荐用 \lvert\rvert 和 \lVert\rVert 取而代之。

```md
$$ \Biggl(\biggl(\Bigl(\bigl((x)\bigr)\Bigr)\biggr)\Biggr) $$
$$ \Biggl[\biggl[\Bigl[\bigl[[x]\bigr]\Bigr]\biggr]\Biggr] $$
$$ \Biggl \{\biggl \{\Bigl \{\bigl \{\{x\}\bigr \}\Bigr \}\biggr \}\Biggr\} $$
$$ \Biggl\langle\biggl\langle\Bigl\langle\bigl\langle\langle x
\rangle\bigr\rangle\Bigr\rangle\biggr\rangle\Biggr\rangle $$
$$ \Biggl\lvert\biggl\lvert\Bigl\lvert\bigl\lvert\lvert x
\rvert\bigr\rvert\Bigr\rvert\biggr\rvert\Biggr\rvert $$
$$ \Biggl\lVert\biggl\lVert\Bigl\lVert\bigl\lVert\lVert x
\rVert\bigr\rVert\Bigr\rVert\biggr\rVert\Biggr\rVert $$
```

$$ \Biggl(\biggl(\Bigl(\bigl((x)\bigr)\Bigr)\biggr)\Biggr) $$
$$ \Biggl[\biggl[\Bigl[\bigl[[x]\bigr]\Bigr]\biggr]\Biggr] $$
$$ \Biggl \{\biggl \{\Bigl \{\bigl \{\{x\}\bigr \}\Bigr \}\biggr \}\Biggr\} $$
$$ \Biggl\langle\biggl\langle\Bigl\langle\bigl\langle\langle x
\rangle\bigr\rangle\Bigr\rangle\biggr\rangle\Biggr\rangle $$
$$ \Biggl\lvert\biggl\lvert\Bigl\lvert\bigl\lvert\lvert x
\rvert\bigr\rvert\Bigr\rvert\biggr\rvert\Biggr\rvert $$
$$ \Biggl\lVert\biggl\lVert\Bigl\lVert\bigl\lVert\lVert x
\rVert\bigr\rVert\Bigr\rVert\biggr\rVert\Biggr\rVert $$

### 矩阵

amsmath 的 pmatrix, bmatrix, Bmatrix, vmatrix, Vmatrix 等环境可以在矩阵两边加上各种分隔符。

```md
$$
\begin{pmatrix} a&b\\c&d \end{pmatrix} \quad
\begin{bmatrix} a&b\\c&d \end{bmatrix} \quad
\begin{Bmatrix} a&b\\c&d \end{Bmatrix} \quad
\begin{vmatrix} a&b\\c&d \end{vmatrix} \quad
\begin{Vmatrix} a&b\\c&d \end{Vmatrix} \quad
$$
```

$$
\begin{pmatrix} a&b\\c&d \end{pmatrix} \quad
\begin{bmatrix} a&b\\c&d \end{bmatrix} \quad
\begin{Bmatrix} a&b\\c&d \end{Bmatrix} \quad
\begin{vmatrix} a&b\\c&d \end{vmatrix} \quad
\begin{Vmatrix} a&b\\c&d \end{Vmatrix} \quad
$$

```md
Lewlh has a little matrix:
$$ ( \begin{smallmatrix} a&b\\c&d \end{smallmatrix} ) $$
```

Lewlh has a little matrix:
$$ ( \begin{smallmatrix} a&b\\c&d \end{smallmatrix} ) $$

### 对齐

需要对齐的公式，可以使用 aligned 次环境来实现，它必须包含在数学环境之内。

```md
$$\begin{aligned}
x ={}& a+b+c+{} \\
&d+e+f+g
\end{aligned}$$
```

$$\begin{aligned}
x ={}& a+b+c+{} \\
&d+e+f+g
\end{aligned}$$

### 分段函数

分段函数可以用cases次环境来实现，它必须包含在数学环境之内。

```md
$$ y= \begin{cases}
-x,\quad x\leq 0 \\
x,\quad x>0
\end{cases} $$
```

$$ y= \begin{cases}
-x,\quad x\leq 0 \\
x,\quad x>0
\end{cases} $$