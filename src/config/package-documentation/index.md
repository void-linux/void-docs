# 软件包文档

Void Linux 中最常见的文档形式是 [man 手册页](./man.md)。

许多软件包提供其他格式的文档，比如 HTML。这些文档一般可以在 `/usr/share/doc/<package>` 目录下找到。

大型的文档可能会被分割为单独的 `*-doc` 软件包，比如 `julia-doc`，这在编程语言、数据和大型的软件库中很常见。

除了上游提供的文档，软件包还可能携带由打包者贡献的、针对 Void 的文档，这些文档会被放在 `/usr/share/doc/<package>/README.voidlinux`。
