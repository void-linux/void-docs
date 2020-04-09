# Submitting Changes

Proposed changes should be submitted as pull-requests to the
[void-docs](https://github.com/void-linux/void-docs) repository on
[GitHub](https://github.com/). Please note that, unlike a wiki, submissions will
be reviewed before they are merged. If any changes are required they will need
to be made before a pull-request is accepted. This process is in place to ensure
the quality and standards of the handbook are sustained.

## Requirements

To clone the repository and push changes
[git(1)](https://man.voidlinux.org/git.1) is required, which is available as the
`git` package.

Building the Void Handbook locally requires
[mdBook](https://rust-lang-nursery.github.io/mdBook/), which can be installed
with the `mdBook` package on Void. At the root of the void-docs repository
`mdbook serve` can be run to serve the docs on your localhost.

## Forking

To fork the repository a [GitHub account](https://github.com/join) is needed.
After the account is created follow GitHub's
[guide](https://help.github.com/en/articles/fork-a-repo) on setting up a fork.

Clone the repository onto your computer, enter it, and create a new branch:

```
$ git clone https://github.com/YOUR_USERNAME/void-docs.git
$ cd void-docs
$ git checkout -b <BRANCH_NAME>
```

After editing the file(s), commit the changes and push them to the forked
repository:

```
$ git add <EDITED_FILE(S)>
$ git commit -m "<COMMIT_MESSAGE>"
$ git push --set-upstream origin <BRANCH_NAME>
```

> The commit message should be in the form of `section: what was changed`

Pull requests should only contain a single commit. If a change is made after the
initial commit `git add` the changed files and then run `git commit --amend`.
The updated commit will need to be force pushed: `git push --force`.

If multiple commits are made they will need to be squashed into one with `git
rebase -i HEAD~X` where X is the number of commits that need to be squashed. An
editor will appear to choose which commits to squash. A second editor will
appear to choose the commit message. See
[git-rebase(1)](https://man.voidlinux.org/git-rebase.1) for more information.
The updated commit will need to be force pushed: `git push --force`.
