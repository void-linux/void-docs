# Making a release

The sources for the Void Handbook are used in two ways:

- Generating the online documentation in <https://docs.voidlinux.org/>;
- Transpilation into multiple formats for distribution in the `void-docs`
   package.

For the latter, we currently depend on the `pandoc` utility, which unfortunately
isn't available on all platforms that Void supports. Therefore, to allow the
`void-docs` package to be created successfully on any platform, we distribute a
tarball with pre-generated artifacts.

In order to generate this tarball, which should be included in all Void Docs
release, the following steps must be run:

- Run `res/build.sh` to build all of the artifacts.
- Run `res/tarball.sh` to generate the distribution tarball.

Then, someone with a generated tarball will have to:

- Unpack the tarball itself;
- Unpack the `artifacts.tar.gz` tarball inside it;
- Run `res/build.sh` with the `ONLY_VOID_DOCS` environment variable set to `1`;
- Run `res/install.sh` with the appropriate `PREFIX` and `DESTDIR` environment
   variables.
