# PHP

There are two ways to install PHP packages with XBPS:

1. Using the versioned packages (recommended).
2. Using the meta-packages.

## Versioned PHP Packages

It is generally recommended to use versioned PHP packages (e.g. `php8.1`,
`php8.1-apcu`, etc.) for most use cases as this ensures a consistent environment
on updates with minimal or no intervention required.

## PHP Meta-packages

In Void, the `php` package is a meta-package that points to the latest upstream
PHP version. This convention is followed by all packages prefixed with `php-`,
such as `php-fpm`, as well as `xdebug` and `composer`. See [the `php`
template](https://github.com/void-linux/void-packages/blob/master/srcpkgs/php/template)
for a complete list. It is recommended to only use these meta-packages for
development purposes.

When using a PHP meta-package, be warned that updating may require manual
intervention if a new major PHP version has been added to the repository. As a
part of the version change, the configuration location will change to reflect
the new version. For example, upgrading from 8.0 to 8.1 would result in the
configuration path changing from `/etc/php8.0` to `/etc/php8.1`. Any
customizations that have been made need to be manually applied to the new
configuration directory.

`php-fpm` updates require special care since they include a runit service. In
this case, ensure that the new runit service is started and that applications
using the previous version of `php-fpm` can access the new `php-fpm` instance.
In particular, make sure any applications accessing the FPM instance have the
correct TCP/unix socket address.
