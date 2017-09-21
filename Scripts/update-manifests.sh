#!/bin/sh
set -e
export BRANCHES="cm-10.1 cm-10.2 cm-11.0 cm-12.0 cm-12.1 cm-13.0 cm-14.1 lineage-15.0"

(cd manifest-all && ./aosp.sh && ./mkmanifest.py)
mv manifest-all/default.xml split-kernels_and_devices-manifest/

for branch in $BRANCHES; do
	echo $branch
	(cd manifest-single-branch && ./mkmanifest.sh $branch)
	mv manifest-single-branch/$branch.xml split-kernels_and_devices-manifest/
done

(cd split-kernels_and_devices-manifest && ./split.py)
mv split-kernels_and_devices-manifest/*.xml ..
