#!/bin/sh

die() {
	printf '%s\n' "$*" >&2
	exit 1
}

command -v git >/dev/null 2>&1 ||
die "neither chroot-git nor git could be found!"

tip="$(git rev-list -1 --parents HEAD)"
case "$tip" in
	# This is a merge commit, pick last parent
	*" "*" "*) tip="${tip##* }" ;;
	# This is a non-merge commit, pick itself
	*)         tip="${tip%% *}" ;;
esac

base="$(git merge-base origin/HEAD "$tip")"

[ $(git rev-list --count "$tip" "^$base") -lt 20 ] || {
	echo "::error title=Branch out of date::Your branch is too out of date. Please rebase on upstream and force-push."
	exit 1
}

status=0

for cmt in $(git rev-list --abbrev-commit $base..$tip)
do
    git cat-file commit "$cmt" |
    awk -vC="$cmt" '
    # skip header
    /^$/ && !msg { msg = 1; next }
    !msg { next }
    # 3: long-line-is-banned-except-footnote-like-this-for-url
    (NF > 2) && (length > 80) { print "::error title=Commit Lint::" C ": long line: " $0; exit 1 }
    !subject {
        if (length > 50) { print "::warning title=Commit Lint::" C ": subject is a bit long" }
        if (!($0 ~ ":")) { print "::error title=Commit Lint::" C ": subject does not follow CONTRIBUTING.md guidelines"; exit 1 }
        subject = 1; next
    }
    /^$/ { body = 1; next }
    !body { print "::error title=Commit Lint::" C ": second line must be blank"; exit 1 }
    ' || status=1
done
exit $status
