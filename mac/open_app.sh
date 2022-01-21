#!/bin/zsh
find /Applications -depth 1 -maxdepth 1 -name "*.app" 2>/dev/null > /tmp/appnames
find /System/Applications -depth 1 -maxdepth 1 -name "*.app" 2>/dev/null >> /tmp/appnames
#open "$(cat /tmp/appnames | fzf -e)"
#echo $(cat /tmp/appnames | fzf -e)
rm /tmp/appnames
