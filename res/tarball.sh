#!/bin/sh -e

tag="${1?Please specify a tag}"

# archive all artifacts into a separate zip, because
# git-archive can't really handle this
tar cvf artifacts.tar.gz mandoc/ book/

git archive --verbose --add-file=artifacts.tar.gz \
	--output="void-docs-$tag.tar.gz" "$tag"
