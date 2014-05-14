#!/bin/sh
URLS=""
for BRANCH in gingerbread ics jellybean cm-10.1 cm-10.2 cm-11.0; do
	URLS="$URLS https://raw.github.com/CyanogenMod/android/$BRANCH/default.xml"
done
curl --compressed -L $URLS | grep 'remote="aosp"' | grep -Eo 'name=".*"' | cut -d'"' -f2 | sort -u > aosp.txt
