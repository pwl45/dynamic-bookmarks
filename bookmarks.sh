#!/usr/bin/env bash

# A simple script to read a list of web bookmarks and open one of them in a web browser. 
# dependencies: dmenu, xclip, a web browser
# I have web_bookmarks.sh mapped to alt+b, web_bookmarks.sh -n to alt+shift+b, and web_bookmarks.sh -c alt+y (vim-like)

# Change this if you use a different browser
WEB_BROWSER="brave-browser"
bookmarks_file="$HOME/scripts/bookmarks"
warn () {
    echo "$0:" "$@" >&2
}
die () {
    rc=$1
    shift
    warn "$@"
    exit $rc
}

# Check dmenu installation
which dmenu >/dev/null || die 1 "dmenu not found; install from https://tools.suckless.org/dmenu/"
# Check browser installation
which $WEB_BROWSER >/dev/null || die 1 "Web browser \"$WEB_BROWSER\" not found in path. Make sure you have it installed."
# Check bookmarks file
stat $bookmarks_file >/dev/null || die 1 "$bookmarks_file not found: make sure you have a bookmark list at that $bookmarks_file."

# Handle args... maybe more verbose than is necessary
FLAGS=""
while [[ $# -gt 0 ]]
do
	key=$1
	case $key in
		-c|--clipboard)
			TOCB=true
			;;
		# This flag works for chrome, brave, and firefox, which is close enough to universal for me. 
		-n|--new-window)
			FLAGS="--new-window $FLAGS"
			;;
		*)
			warn "Unknown argument $1. Ignoring."
			;;
	esac
	shift
done

# ------------------------------Main part of program-----------------------------------------------
# Pipe bookmark names to dmenu
bookmark=$(awk -F '\t' '{print $1}' $bookmarks_file | dmenu -i)

# Search bookmarks file for bookmark name, print bookmark url
# awk: separated by tab, set variable bookmark, look for first field equal to bookmark,
#      print second field when found
url=$( awk -F '\t' -v bookmark="$bookmark" '$1 == bookmark {print $2}' $bookmarks_file )
# -------------------------------------------------------------------------------------------------

if [ -z $TOCB ]; then
	if [ ! -z $url ]
	then
		$WEB_BROWSER $FLAGS $url
	fi
else
	if [ ! -z $url ]
	then
		echo -n $url | xclip -selection c
	fi
fi

