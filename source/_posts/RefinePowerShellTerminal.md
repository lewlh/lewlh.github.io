---
title: 像oh-my-zsh那样使用PowerShell
date: 2025-02-15 10:16:29
tags:
    - Oh My Posh
    - PowerShellGet
    - PSReadLine
    - posh-git
---

![oh-my-posh](/images/202502/ohmyposh.png)

最近经常使用 PowerShell 安装一些开源的项目，拉代码，安装依赖，一些命令需要来回复制，效率非常底下，非常想念在类unix系统下面那些好用的命令行工具，如 [oh-my-zsh](https://ohmyz.sh/)。网上搜了一下，意外发现 PowerShell 下面也有类似的工具名叫[oh-my-posh](https://ohmyposh.dev/)，感觉还挺不错。故把安装的过程记录一下。

<!-- more -->

**********

综合互联网其他网友的方案，为实现像 oh-my-zsh 那样使用 PowerShell，需要安装以下软件：

+ [Windows Terminal](https://apps.microsoft.com/detail/9n0dx20hk701?rtc=1&hl=zh-CN&gl=CN)，在 win11 中系统已经安装好了；
+ 安装 [Nerd font](https://www.nerdfonts.com/font-downloads) 字体，其中 [CaskaydiaCove Nerd Font](https://objects.githubusercontent.com/github-production-release-asset-2e65be/27574418/c5dcd41c-e372-414f-b240-099b4f02dc38?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=releaseassetproduction%2F20250215%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250215T141643Z&X-Amz-Expires=300&X-Amz-Signature=a78b9cdaf82c6a6e0b3e19e85ca35dc85d84519ec297d07e43f89c806f659b4d&X-Amz-SignedHeaders=host&response-content-disposition=attachment%3B%20filename%3DCascadiaCode.zip&response-content-type=application%2Foctet-stream) 字体在自述中提到 ` Info: A fun, new monospaced font that includes programming ligatures and is designed to enhance the modern look and feel of the Windows Terminal` 声称在 Windows Terminal 有专门的适配字体monospaced font，因此我选择使用它；
+ [PowerShell 7](https://github.com/PowerShell/PowerShell)
+ [PowerShellGet](https://github.com/PowerShell/PowerShellGet) 是 Windows 平台上的包管理器，主要用于管理 PowerShell 模块，但也支持其他类型的包。
+ [Oh My Posh](https://ohmyposh.dev/)是一款用于美化和定制终端提示符的工具。它可以在各种操作系统和终端中使用，包括 Windows、macOS 和 Linux。通过 Oh-my-posh，你可以轻松地更改终端提示符的外观，添加各种有用的信息，例如当前目录、Git 分支、电池状态等。
+ [posh-git](https://github.com/dahlbyk/posh-git)是一款用于 Windows 系统的 PowerShell 扩展模块，它主要为 Git 提供了更加丰富且人性化的命令行界面体验。
+ [PSReadLine](https://github.com/PowerShell/PSReadLine)用于增强命令行编辑体验的模块，提供语法高亮/命令预测/历史记录管理以及提供了丰富的快捷键和编辑命令。

## 安装指南

### 字体安装

下载好字体安装压缩包，解压后安装 mono 字体：

```powershell
    目录: C:\Users\lewlh\Downloads\share\CascadiaCode


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         2025/2/15     22:19        2756920 CaskaydiaCoveNerdFont-Bold.ttf
-a----         2025/2/15     22:19        2606596 CaskaydiaCoveNerdFont-BoldItalic.ttf
-a----         2025/2/15     22:19        2758276 CaskaydiaCoveNerdFont-ExtraLight.ttf
-a----         2025/2/15     22:19        2606992 CaskaydiaCoveNerdFont-ExtraLightItalic.ttf
-a----         2025/2/15     22:19        2605352 CaskaydiaCoveNerdFont-Italic.ttf
-a----         2025/2/15     22:19        2759040 CaskaydiaCoveNerdFont-Light.ttf
-a----         2025/2/15     22:19        2608868 CaskaydiaCoveNerdFont-LightItalic.ttf
-a----         2025/2/15     22:19        2755216 CaskaydiaCoveNerdFont-Regular.ttf
-a----         2025/2/15     22:19        2756324 CaskaydiaCoveNerdFont-SemiBold.ttf
-a----         2025/2/15     22:19        2606140 CaskaydiaCoveNerdFont-SemiBoldItalic.ttf
-a----         2025/2/15     22:19        2757672 CaskaydiaCoveNerdFont-SemiLight.ttf
-a----         2025/2/15     22:19        2607848 CaskaydiaCoveNerdFont-SemiLightItalic.ttf
-a----         2025/2/15     22:19        2668696 CaskaydiaCoveNerdFontMono-Bold.ttf
-a----         2025/2/15     22:19        2520856 CaskaydiaCoveNerdFontMono-BoldItalic.ttf
-a----         2025/2/15     22:19        2670056 CaskaydiaCoveNerdFontMono-ExtraLight.ttf
-a----         2025/2/15     22:19        2521248 CaskaydiaCoveNerdFontMono-ExtraLightItalic.ttf
-a----         2025/2/15     22:19        2519608 CaskaydiaCoveNerdFontMono-Italic.ttf
-a----         2025/2/15     22:19        2670816 CaskaydiaCoveNerdFontMono-Light.ttf
-a----         2025/2/15     22:19        2523124 CaskaydiaCoveNerdFontMono-LightItalic.ttf
-a----         2025/2/15     22:19        2666992 CaskaydiaCoveNerdFontMono-Regular.ttf
-a----         2025/2/15     22:19        2668100 CaskaydiaCoveNerdFontMono-SemiBold.ttf
-a----         2025/2/15     22:19        2520400 CaskaydiaCoveNerdFontMono-SemiBoldItalic.ttf
-a----         2025/2/15     22:19        2669448 CaskaydiaCoveNerdFontMono-SemiLight.ttf
-a----         2025/2/15     22:19        2522104 CaskaydiaCoveNerdFontMono-SemiLightItalic.ttf
-a----         2025/2/15     22:19        2756696 CaskaydiaCoveNerdFontPropo-Bold.ttf
-a----         2025/2/15     22:19        2606372 CaskaydiaCoveNerdFontPropo-BoldItalic.ttf
-a----         2025/2/15     22:19        2758052 CaskaydiaCoveNerdFontPropo-ExtraLight.ttf
-a----         2025/2/15     22:19        2606768 CaskaydiaCoveNerdFontPropo-ExtraLightItalic.ttf
-a----         2025/2/15     22:19        2605128 CaskaydiaCoveNerdFontPropo-Italic.ttf
-a----         2025/2/15     22:19        2758816 CaskaydiaCoveNerdFontPropo-Light.ttf
-a----         2025/2/15     22:19        2608644 CaskaydiaCoveNerdFontPropo-LightItalic.ttf
-a----         2025/2/15     22:19        2754992 CaskaydiaCoveNerdFontPropo-Regular.ttf
-a----         2025/2/15     22:19        2756100 CaskaydiaCoveNerdFontPropo-SemiBold.ttf
-a----         2025/2/15     22:19        2605916 CaskaydiaCoveNerdFontPropo-SemiBoldItalic.ttf
-a----         2025/2/15     22:19        2757448 CaskaydiaCoveNerdFontPropo-SemiLight.ttf
-a----         2025/2/15     22:19        2607624 CaskaydiaCoveNerdFontPropo-SemiLightItalic.ttf
-a----         2025/2/15     22:19           4395 LICENSE
-a----         2025/2/15     22:19           3610 README.md
```

直击点击字体文件即可安装，安装完字体后，在 WindowsTerminal 中设置字体：打开Windows Terminal 设置项 -> 默认值 -> 外观 -> 字体 -> 选择 *CaskaydiaCove Nerd Font Mono*  -> 点击保存：

![SetFont](/images/202502/windowTerminalSetFont.jpg)

### 使用WinGet安装PowerShell

使用 WindowsTerminal 打开 Windows PowerShell 窗口，执行以下命令安装 PowerShell：

```powershell
winget install --id Microsoft.PowerShell --source winget
```

安装完成后，WindowsTerminal 将会增加一个新的启动项 **PowerShell**，该项目与 **Windows PowerShell** 是不一样的，后续都需要通过 **PowerShell** 使用 PowerShell 7。

### 安装PowerShellGet

以系统管理员权限打开**PowerShell**终端，执行以下命令：

```powershell
Install-Module -Name PowerShellGet -Force
```

### 安装oh-my-posh

以系统管理员权限打开**PowerShell**终端，执行以下命令：

```powershell
winget install JanDeDobbeleer.OhMyPosh -s winget
已找到 Oh My Posh [JanDeDobbeleer.OhMyPosh] 版本 24.19.0
此应用程序由其所有者授权给你。
Microsoft 对第三方程序包概不负责，也不向第三方程序包授予任何许可证。
正在下载 https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v24.19.0/install-x64.msi
  ██████████████████████████████  5.68 MB / 5.68 MB
已成功验证安装程序哈希
正在启动程序包安装...
已成功安装
```

### 安装posh-git

以系统管理员权限打开**PowerShell**终端，执行以下命令：

```powershell
PowerShellGet\Install-Module posh-git -Scope CurrentUser -Force
```

### 安装PSReadLine

以系统管理员权限打开**PowerShell**终端，执行以下命令：

```powershell
Install-Module PSReadLine -Force
```

### 编辑oh-my-posh配置文件

打开**PowerShell**终端，执行以下命令编辑配置文件 `code $PROFILE`：

```ps1
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete #Tab键会出现自动补全菜单
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward #上下方向键箭头，搜索历史中进行自动补全

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/jandedobbeleer.omp.json" | Invoke-Expression
Import-Module posh-git # git的自动补全
```

保存修改，重新打开一个新的**PowerShell**终端，将会看到以下效果：

![oh-my-posh-terminal](/images/202502/ohmyposhTerminal.png)


## References

+ [让Powershell拥有和zsh一样的自动补全，大幅提升Windows的开发体验，保姆级教程](https://juejin.cn/post/7139514254801141791)
+ [打造好用的PowerShell媲美oh-my-zsh](https://blog.unclezs.com/pages/9b6e12/#%E7%AE%80%E4%BB%8B)
+ [使用 WinGet 安装 PowerShell（建议）](https://learn.microsoft.com/zh-cn/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.5)