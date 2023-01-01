# [本地化与翻译]

要获取当前启用的语言环境列表，请运行 

```
$ locale -a
```

## 启用语言环境

要启用某个地区性语言，请取消注释或在以下文件中添加相关行
`/etc/default/libc-locales`和[强制重新配置](../xbps/index.md)的相关行。
`glibc-locales`包。

## 设置系统语言环境

在 `/etc/locale.conf` 中写 `LANG=xxxx`

## 应用程序语言环境

一些程序的翻译在一个单独的软件包中，必须安装才能使用它们。你可以在软件包库中[搜索](../xbps/index.md)所需的语言（如 "德语 "或 "葡萄牙语"），并安装与你使用的应用程序相关的软件包。一个特别相关的情况是在安装 LibreOffice 套件中的单个软件包时，例如 `libreoffic-writer` ，它需要安装至少一个 `libreoffic-i18n-*` 软件包才能正常工作。在安装 `libreoffice` 元包时，会自动安装翻译包。
