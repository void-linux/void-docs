# About

Void is an independent Linux distribution developed in the spare time of a
handful of developers. We do this for fun and hope that our work will be useful
to others. Void is generally considered stable enough for daily use, and
breaking changes are few and far between.

Some things that make Void unique in the crowded world of Linux distributions
include our package manager, XBPS, which is developed in-house and is extremely
fast. XBPS performs checks when installing updates to ensure that libraries
aren't moved to incompatible versions, thus preventing a random update from
breaking your system. XBPS is developed at
<https://github.com/void-linux/xbps/>.

Void is also set apart from other projects by our first class support of the
musl C library, which focuses on standards compliance and correctness. The musl
C project allows us to also build very resilient systems as it is practical to
statically link certain components on our musl flavors whereas it would not be
practical to do so with glibc.

Along with our support of musl C, we also use the LibreSSL libraries instead of
the more traditional OpenSSL counterpart. LibreSSL developers have shown time
and time again that they are dedicated to the security, quality, and
maintainability of this critical library.

A final distinguishing characteristic of Void is our choice of program for
[init(8)](https://man.voidlinux.org/init.8). Void Linux boots with smarden
runit, a very small service supervision system. The small codebase of runit
allows us to support a second libc without significant effort, something that
would not have been possible with other options available today. You can learn
more about runit on its website <http://smarden.org/runit/>.
