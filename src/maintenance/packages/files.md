# Finding files

To search a file in packages you can use one of two methods

The `xtools` package contains the `xlocate` utility that works like
[locate(1)](https://man.voidlinux.org/locate.1) but for all files in the void
package repository.

```
# xbps-install -Su xtools

$ xlocate -S
From https://repo.voidlinux.org/xlocate/xlocate +
16d97bfe86...2ad1a4a8d1 master -> master (forced update)
$ xlocate fizz
nim-0.17.0_1 /usr/lib/nim/examples/fizzbuzz.nim ponysay-3.0.2_1
/usr/share/ponysay/ponies/cherryfizzy.pony ->
/usr/share/ponysay/ponies/cherrycola.pony ponysay-3.0.2_1
/usr/share/ponysay/ttyponies/cherryfizzy.pony ->
/usr/share/ponysay/ttyponies/cherrycola.pony supertux2-data-0.5.1_1
/usr/share/supertux2/sounds/fizz.wav
```

It is also possible to use `xbps-query` to find files, but this is strongly
discouraged. It requires `xbps-query` to download parts of every package to find
the file requested. `xlocate`, on the other hand, is able to query a locally
cached index of all files, so no network is required to query for files.

```
$ xbps-query -Ro /usr/bin/xlocate
xtools-0.46_1: /usr/bin/xlocate (regular file)
```
