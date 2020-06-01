# NAME

void-docs - Void Linux documentation package

# SYNOPSIS

*/usr/share/doc/void/html* - documentation in HTML format

*/usr/share/doc/void/markdown* - documentation in Markdown format

*/usr/share/doc/void/mandoc* - documentation in roff format

# DESCRIPTION

The `void-docs` package contains a snapshot of the online documentation from
https://docs.voidlinux.org, which intends to document installation,
configuration and system management for Void Linux. It is packaged in three
formats.

*/usr/share/doc/void/html* - can be viewed with any browser, such as Mozilla
Firefox or Chromium. Recommended when a GUI session is available, because it
allows easy navigation between the documentation pages and has the same format
as the official website. Can be accessed by pointing the browser to the
`/usr/share/doc/void/html/index.html` file.

*/usr/share/doc/void/markdown* - can be viewed as text files, using **cat(1)**
or **less(1)**, or as a formatted markdown file, with applications such as
**mdcat** or **glow**. The table of contents can be accessed in the
`/usr/share/doc/void/markdown/SUMMARY.md` file.

*/usr/share/doc/void/mandoc* - can be viewed using **mandoc(1)**. Using
**mandoc(1)** with the **-a** option, which enables a pager, is recommended.

# EXAMPLES

Viewing the homepage of the HTML documentation with **qutebrowser(1)**:

```
$ qutebrowser /usr/share/doc/void/html/index.html
```

Viewing the summary of the markdown documentation with **less(1)**:

```
$ less /usr/share/doc/void/markdown/SUMMARY.md
```

Viewing the "Kernel" page of the markdown documentation with **mdcat**:

```
$ mdcat /usr/share/doc/void/markdown/config/kernel.md
```

Viewing the "Cron" page of the roff documentation with **mandoc(1)**:

```
$ mandoc -a /usr/share/doc/void/mandoc/config/cron.7
```

# AVAILABILITY

This man page is part of the void-docs package and is available from
https://github.com/void-linux/void-docs.

# BUGS

The Void Linux documentation tries to limit itself to content that is specific
to Void. Therefore, if you feel something is missing, it might have been
deliberate. However, if there is any information that is mistaken, outdated or
indeed missing, please report an issue at
https://github.com/void-linux/void-docs.
