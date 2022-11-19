#!/usr/bin/env bash
# Simplified but less-robust version of this program

bookmarks_file="$( dirname $0 )/bookmarks"
# Search bookmarks file for bookmark name, print bookmark url
bookmark=$(awk -F '\t' '{print $1}' $bookmarks_file | dmenu -i) || exit $?

# awk: separated by tab, set variable bookmark, look for first field equal to bookmark,
#      print second field when found
url=$( awk -F '\t' -v bookmark="$bookmark" '$1 == bookmark {print $2; exit 0} END {exit 1}' $bookmarks_file )

# Don't run if url isn't set
test -z "$url" || firefox $url
