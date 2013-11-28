#!/bin/sh
if [ $# -ne 1 -a $# -ne 2 ]; then
	printf "Usage: ${0##*/} <branch> [output name]\n\n"
	printf "Output name is optional. Branch will be used if omitted.\n"
	exit 1
fi

BRANCH="$1"
OUTPUT="$(echo "$BRANCH" | sed -e 's!/!-!').xml"
URL="https://raw.github.com/CyanogenMod/android/$BRANCH/default.xml"
if [ $# -eq 2 ]; then
	OUTPUT="${2%.xml}.xml"
fi

REPO_LIST="../manifest-all/repos.txt"

if type curl >/dev/null; then
	DL="curl --compressed -s"
elif type wget >/dev/null; then
	DL="wget -q -O-"
elif type lynx >/dev/null; then
	DL="lynx -source"
else
	printf "No download tool found.\n"
	printf "You need to have curl, wget or lynx installed.\n"
	exit 1
fi

for x in grep sort awk sed; do
	if ! type $x >/dev/null; then
		printf "You need $x installed for this.\n"
		exit 1
	fi
done

if [ -s "$OUTPUT" ]; then
	read -r -p "$OUTPUT already exists. Do you want to overwrite? [Y/n] " REPLY
	printf "\n"
	if [ "$REPLY" != "Y" -a "$REPLY" != "y" -a -n "$REPLY" ]; then
		printf "Not overwriting. Exiting...\n"
		exit
	fi
fi


if ! grep -m1 -q -E "\b$BRANCH\b" "$REPO_LIST"; then
	printf "No repos found. Does branch $BRANCH exist?\n"
	printf "Maybe use ../all/mkmanifest.py first to refresh repo data.\n"
	exit 1
fi

printf "Saving manifest for branch $BRANCH to $OUTPUT\n"
trap "rm -f '$OUTPUT.tmp'" EXIT
echo -n > "$OUTPUT.tmp"

grep -E "\b$BRANCH\b" "$REPO_LIST" | awk '{print $1}' | while read repo; do
	printf "\t<project name=\"$repo\" />\n" >> "$OUTPUT.tmp"
done


sort -u -o "$OUTPUT.tmp" "$OUTPUT.tmp"

printf "\n\n" >> "$OUTPUT.tmp"
$DL "$URL" | grep 'remote="aosp"' | sed 's/^\s+/\t/' >> $OUTPUT.tmp


sed -e "s/revision=\".*\"/revision=\"refs/heads/$BRANCH\"/" -i "manifest.xml.head"
cat "manifest.xml.head" "$OUTPUT.tmp" "manifest.xml.tail" > "$OUTPUT"
sed -e "s/revision=\".*\"/revision=\"master\"/" -i "manifest.xml.head"

printf "Manifest saved to $OUTPUT\n"
