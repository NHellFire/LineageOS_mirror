#!/bin/bash

if ! ls *.xml &> /dev/null; then
	printf "No manifests.\n"
	exit
fi

for manifest in *.xml; do
	KERNEL_MANIFEST="${manifest/.xml/_kernels.xml}"
	grep -E "CyanogenMod/(android_|\w+-)kernel" "$manifest" > "$KERNEL_MANIFEST.tmp"
	if [ -s "$KERNEL_MANIFEST.tmp" ]; then
		cat "manifest.xml.head" "$KERNEL_MANIFEST.tmp" "manifest.xml.tail" > "$KERNEL_MANIFEST"
		grep -Ev "CyanogenMod/(android_|\w+-)kernel" "$manifest" > "$manifest.tmp"
		mv "$manifest.tmp" "$manifest"
	fi
	rm "$KERNEL_MANIFEST.tmp"
done