# Finding files

To search a file in packages you can use one of two methods

The first method is to use
[xbps-query(1)](https://man.voidlinux.org/xbps-query.1) which is okay
to use if you want to just look for local files, you can use it to
search for remote files with the `-R` flag but its very slow compared
to the second method using `xlocate`.

```
$ xbps-query -o /usr/bin/xlocate
xtools-0.46_1: /usr/bin/xlocate (regular file)
```

The `xtools` package contains the `xlocate` utility that works like
[locate(1)](https://man.voidlinux.org/locate.1) but for all files in
the void package repository.

```
# xbps-install -Su xtools
```
```
$ xlocate -S
From https://repo.voidlinux.org/xlocate/xlocate
 + 16d97bfe86...2ad1a4a8d1 master -> master (forced update) $ xlocate
fizz nim-0.17.0_1 /usr/lib/nim/examples/fizzbuzz.nim ponysay-3.0.2_1
/usr/share/ponysay/ponies/cherryfizzy.pony ->
/usr/share/ponysay/ponies/cherrycola.pony ponysay-3.0.2_1
/usr/share/ponysay/ttyponies/cherryfizzy.pony ->
/usr/share/ponysay/ttyponies/cherrycola.pony supertux2-data-0.5.1_1
/usr/share/supertux2/sounds/fizz.wav
```
