#!/usr/bin/env bash

# A simple script to read a list of web bookmarks and open one of them in a web browser. 
# dependencies: dmenu, xclip, a web browser
# I have web_bookmarks.sh mapped to alt+b, web_bookmarks.sh -n to alt+shift+b, and web_bookmarks.sh -c alt+y (vim-like)

# Web browser to use, can be overwritten by -b BROWSER
WEB_BROWSER="firefox"

# bookmarks file to use, can be overwritten by -f FILE
bookmarks_file="$HOME/dynamic-bookmarks/bookmarks"
warn () {
    echo "$0:" "$@" >&2
}
die () {
    rc=$1
    shift
    warn "$@"
    exit $rc
}


# cat $0
# exit(0)
FLAGS=""
while [[ $# -gt 0 ]]; do
	key=$1
	case $key in
		-c|--clipboard) # makes other flags irrelevant
			TOCB=true
			;;
		-n|--new-window) 
			# This flag works for chrome, brave, and firefox, which is close enough to universal for me. 
			FLAGS="--new-window $FLAGS"
			;;
		-b|--browser)
			WEB_BROWSER=$2
			echo "setting browser to $2"
			shift
			;;
		-f|--file)
			bookmarks_file=$2
			echo "setting bookmarks file to $2"
			shift
			;;
		-a|--additional-flag)
			FLAGS="$2 $FLAGS"
			shift
			;;
		*)
			warn "Unknown argument $1. Ignoring."
			;;
	esac
	shift
done

# Check dmenu installation
which dmenu >/dev/null || die 1 "dmenu not found; install from https://tools.suckless.org/dmenu/"
# Check browser installation
which $WEB_BROWSER >/dev/null || die 1 "Web browser \"$WEB_BROWSER\" not found in path. Make sure you have it installed."
# Check bookmarks file
stat $bookmarks_file >/dev/null || die 1 "$bookmarks_file not found: make sure you have a bookmark list at that $bookmarks_file."

# ------------------------------Main part of program-----------------------------------------------
# Pipe bookmark names to dmenu
bookmark=$(awk -F '\t' '{print $1}' $bookmarks_file | dmenu -i) || die $? "No bookmark chosen"

# Search bookmarks file for bookmark name, print bookmark url
# awk: separated by tab, set variable bookmark, look for first field equal to bookmark,
#      print second field when found
url=$( awk -F '\t' -v bookmark="$bookmark" '$1 == bookmark {print $2}' $bookmarks_file )
# -------------------------------------------------------------------------------------------------

if [ ! -z $url ]; then
	if [ -z $TOCB ]; then
		echo -n $url | xargs -r $WEB_BROWSER $FLAGS
	else
		echo -n $url | xclip -selection c
	fi
fi

