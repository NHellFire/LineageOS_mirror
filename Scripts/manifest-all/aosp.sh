#!/bin/sh
URLS=""
BRANCHES="${BRANCHES:-cm-10.1 cm-10.2 cm-11.0 cm-12.0 cm-12.1 cm-13.0 lineage-15.0}"

for BRANCH in $BRANCHES; do
	URLS="$URLS https://raw.github.com/LineageOS/android/$BRANCH/default.xml"
done
curl --compressed -L $URLS | grep 'remote="aosp"' | grep -Eo 'name=".*"' | cut -d'"' -f2 | sort -u > aosp.txt
