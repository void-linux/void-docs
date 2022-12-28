# 关于

欢迎来到 Void 手册! 请无比阅读"[关于本手册](./about-this-handbook.md)" 的部分，以了解如何有效地使用本手册。
本手册的本地部分, 有几种格式,可以通过 `void-docs` 软件包[安装](../xbps/index.md)并使用 [void-docs(1)](https://man.voidlinux.org/void-docs.1) 访问。

Void 是独立的, [滚动](https://en.wikipedia.org/wiki/Rolling_release) Linux 发行版,从头开始开发，不是哪个发行版的分支。注重稳定性大于
[新的技术](https://en.wikipedia.org/wiki/Bleeding_edge_technology). 此外, 还有几个特点使 Void 成为独一无二的存在
 
-  [XBPS](https://github.com/void-linux/xbps) 软件包管理, 它是速度极快, 由 Void 内部开发, XBPS 在更新软件包前会检查兼容性，确保更新不会破坏依赖。
-  [musl libc](https://musl.libc.org/), 专注于标准的遵守和正确性，拥有一流的支持。在 musl 系统上，可以构建出一些 glibc 系统上不可能构建出的静态组件。
   
- [runit](../config/services/index.md) 用于
   [init(8)](https://man.voidlinux.org/init.8) 和服务监视器. runit 允许使用 musl 作为 libc，[systemd](https://www.freedesktop.org/wiki/Software/systemd/) 无法做到这一点。使用 runit 还使得 Void 的核心系统更精简高效，源代码更简洁。

通常，Void 的稳定性足以应对日常使用。Void 由少数开发者在空闲时间里开发，我们以此为乐，希望我们的工作可以帮助到其他人。

“Void”之名来自 C 语言关键字 void，没有什么特殊含义。
