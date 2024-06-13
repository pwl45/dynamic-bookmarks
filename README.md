# dynamic-bookmarks

A script for selecting bookmarks using dmenu. Setting a keybinding for this script allows you to select/open bookmarks with a keybinding, even when you don't have your web browser open.

## Installation
1. Install dmenu
- Install dmenu using the instructions [here](https://tools.suckless.org/dmenu/). You should be able to do so with
```bash
cd $HOME
git clone https://git.suckless.org/dmenu
cd dmenu
make
sudo make install
```
2. Set bookmarks
- `bookmarks.sh` reads a tab separated bookmarks file where each line contains a bookmark name and a bookmark URL separated by a tab. The file [bookmarks](./bookmarks) contains an example.
- By default, `bookmarks.sh` expects to find this file in `$HOME/dynamic-bookmarks/bookmarks`; it can also be specified at the command line with the -f flag (`./bookmarks.sh -f BOOKMARKS_FILE`). 

## Usage
1. Run `./bookmarks.sh -f ./bookmarks`
- `bookmarks.sh` expects your browser to be firefox, if you don't use firefox you can change this in the script or use the -b flag to specify the browser to use from the command line (e.g. `./bookmarks.sh -f bookmarks -b google-chrome` )
2. You should see bookmarks appear at the top of your screen. Start typing to filter. Press enter to select and open. 

## Additional flags
Adding the `-c` or `--cliboard` flag copies the bookmark to your clipboard instead of opening it (e.g. `./bookmarks.sh -f bookmarks -c`)

Adding the `-n` flag or `--new-window` opens the selected bookmark in a new window (instead of a new tab). 
