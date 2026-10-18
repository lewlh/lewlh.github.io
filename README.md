
# Lewlh's blog

[Lewlh 的个人博客](lewlh.github.io) 网页生成器源码,实用 Hexo + Next搭建。

## 日常维护

### 搭建环境

以 MacOS 为例：

+ 安装 node： `brew update && brew install node`
+ 安装 hexo-cli： `npm install hexo-cli -g`
+ 在本项目下安装 npm 包依赖：`npm install`

至此，本地环境搭建完毕。

### 新建一个博客文章

新建一篇博客文章，在`hexo/source/_posts`文件夹下新建md文件(不用加.md后缀）

```bash
hexo new 文件名
```

打开该 文件名.md，编辑文章内容。

### 生成网站文件并部署

```bash
# 生成网页文件
hexo g

# localhost:4000本地预览效果
hexo s

# 部署
hexo clean && hexo deploy
```
