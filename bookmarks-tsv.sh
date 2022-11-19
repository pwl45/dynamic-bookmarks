#!/usr/bin/env bash
#one-liner, less-robust version of this program
dmenu < $HOME/dynamic-bookmarks/bookmarks | cut -f2 | xargs -r firefox "$@"
