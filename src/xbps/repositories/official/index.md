# Official Repositories

Void provides other official repositories, which are maintained by the Void
project, but not installed in the default configuration. The following table
describes XBPS packages you can install to enable additional repositories and
what those repositories contain.

| Package			                    | Description						                                     | Link					                          |
|-------------------------------|-------------------------------------------------------|------------------------------------|
| `void-repo-multilib`		        | 32-bit compatibility packages 			                     | [multilib](./multilib.md)		        |
| `void-repo-mulitlib-nonfree`	 | 32-bit compatibility packages with nonfree components | [multilib-nonfree](./multilib.md)	 |
| `void-repo-nonfree`		         | packages with non-free licenses 			                   | [nonfree](./nonfree.md)			         |
| `void-repo-debug`		           | debug symbols for packages 				                       | [debug](./debug.md)			             |

## Installing

These repositories can be installed from the packages named in the table above.
For example, to install the `nonfree` repository, install the package
`void-repo-nonfree`:

```
# xbps-install -S void-repo-nonfree
```

> Note: These packages only install a repository configuration file in
> `/usr/share/xbps.d`.
