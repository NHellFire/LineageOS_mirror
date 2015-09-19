#!/bin/sh
set -e
BRANCHES="cm-10.1 cm-10.2 cm-11.0 cm-12.0 cm-12.1"

(cd manifest-all && ./aosp.sh && ./mkmanifest.py)
mv manifest-all/default.xml split-kernels_and_devices-manifest/

for branch in $BRANCHES; do
	echo $branch
	(cd manifest-single-branch && ./mkmanifest.sh $branch)
	mv manifest-single-branch/$branch.xml split-kernels_and_devices-manifest/
done

(cd split-kernels_and_devices-manifest && ./split.sh)
mv split-kernels_and_devices-manifest/*.xml ..
