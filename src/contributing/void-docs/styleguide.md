# Style Guide

This style guide is a work in progress to outline the standards for 
contributing to the [void-docs](https://github.com/void-linux/void-docs/)
project. These guidelines are a work in progress.

This section will detail the specific format of the markdown files to be used
in the void-docs mdbook.

## Formatting

Each line should be less than 80 characters, unless there is special
formatting that requires a longer line. Exceptions may include:

  - links which start at the beginning of a new line
  - tables
  - code blocks

## Headers

Headers shall only be in the 
[ATX heading](https://github.github.com/gfm/#atx-headings) format, and are
only to be used heirarchically (i.e do not skip from `#` to `###`.)

## Commands

Command code-blocks should start with a `#` or `$` character, indicating
whether the command should be run as `root` or a regular user, respectively.

For example:

```
# xbps-install -Su
```

And not:

```
$ sudo xbps-install -Su
```

And also not:
```
xbps-install -Su
```

## Links

Auto links (links with the same title as url) shold be use the following
notation:

```
<https://www.example.com/>
```
They should not be formatted like this:
```
[https://www.example.com/](https://www.example.com/)
```
