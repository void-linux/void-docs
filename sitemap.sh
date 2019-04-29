#!/bin/sh

set -e

# functions
fail() {
    echo "$1" 1>&2
    exit 1
}


get_last_mod() {
    if [ ! -f "$1" ]; then
        date --iso-8601
    else
        git log -1 --format="%ci" "$1" | awk '{print $1}'
    fi
}

# vars
book_path="book"
src_path="src"
output="$book_path/sitemap.xml"
changefreq="weekly" # values: always hourly daily weekly monthly yearly never
url_prefix="https://docs.voidlinux.org"

# check if build directory exists
test -d $book_path || fail "Directory $book_path does not exist."

# cleanup
test -f $output && rm $output

# sitemap generator
exec 1> $output

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
echo "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">"

tmp=$(mktemp)

find "$book_path" -type f -name "*.html" > "$tmp"
while IFS= read -r f
do
    p=$(echo "$f" | sed "s/$book_path//g")
    md=$(echo "$p" | sed "s/.html/.md/g")
    lastmod=$(get_last_mod "$src_path$md")
    printf "\t<url>\n"
    printf "\t\t<loc>%s</loc>\n" "$url_prefix$p"
    printf "\t\t<changefreq>%s</changefreq>\n" "$changefreq"
    printf "\t\t<lastmod>%s</lastmod>\n" "$lastmod"
    printf "\t</url>\n"
done < "$tmp"

rm "$tmp"

echo "</urlset>"
