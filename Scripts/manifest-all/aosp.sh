#!/bin/sh
URLS=""
for branch in gingerbread ics jellybean cm-10.1 cm-10.2 cm-11.0; do
	URLS+="https://raw.github.com/CyanogenMod/android/$BRANCH/default.xml "
done
curl --compressed $URLS | grep 'remote="aosp"' | grep -Eo 'name=".*"' | cut -d'"' -f2 > aosp.txt
sort -u -o aosp.txt aosp.txt
