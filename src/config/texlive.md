# TeX Live

In Void, the `texlive-bin` package provides a basic TeX installation, including
the `tlmgr` program. Use `tlmgr` to install TeX packages and package collections
from CTAN mirrors. Install the `gnupg` package to allow `tlmgr` to verify TeX
packages.

The `texlive-bin` package contains the latest TeX Live version; however, earlier
versions, such as `texlive2018-bin`, are also available.

The `texlive` package and `texlive-*` packages are also available, and provide
TeX packages directly via xbps. TeX packages installed via those packages cannot
interact with TeX packages installed directly from CTAN (via `tlmgr`). For
example: `pdflatex` from `texlive-pdflatex` cannot be used to compile a TeX
document that uses a package installed via `tlmgr`; `tlmgr install pdflatex`
would be required for that.

## Configuring TeX Live

After installing TeX Live, update the value of `PATH`:

```
$ source /etc/profile
```

Check that `/opt/texlive/<year>/bin/x86_64-linux` (or
`/opt/texlive/<year>/bin/i386-linux`) is in your `PATH`:

```
$ echo $PATH
```

If required, change the global default paper size:

```
# tlmgr paper <letter|a4>
```

## Installing/Updating TeX packages

To install all available packages:

```
# tlmgr install scheme-full
```

To install specific packages, you can install the collection(s) including them.
To list the available collections:

```
$ tlmgr info collections
```

To see the list of files owned by a collection:

```
$ tlmgr info --list collection-<name>
```

To install the collection:

```
# tlmgr install collection-<name>
```

To install a standalone package, first check if the package exists:

```
$ tlmgr search --global <package>
```

and then install it:

```
# tlmgr install <package>
```

To find the package providing a particular file (for example, a font):

```
$ tlmgr search --file <filename> --global
```

To remove a package or a collection:

```
# tlmgr remove <package>
```

To update installed packages:

```
# tlmgr update --all
```

For a full description, check:

<https://www.tug.org/texlive/doc/tlmgr.html>

## Texinfo PDF and HTML compilation with TeX Live
Texinfo is the documentation system used by GNU and other projects and can
output .info files (with `makeinfo`) to be used with the software `info` or can
be exported into PDFs with `texi2pdf` and HTMLs with `texi2html`. Both PDF and
HTML conversions require a texinfo.tex file which can be installed from tlmgr.

```
# tlmgr install texinfo
```

Other missing files the .texi sources require can be installed the same way.

More informations about texinfo on ctan, check:

<https://ctan.org/pkg/texinfo>
