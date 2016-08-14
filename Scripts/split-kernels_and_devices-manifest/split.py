#!/usr/bin/python
from glob import glob
from sys import exit
import re

DEVICE_PATTERN = "CyanogenMod/android_device_"
KERNEL_PATTERN = re.compile(r"CyanogenMod/(android_|\w+-)kernel")

MANIFESTS = glob("*.xml")

if not len(MANIFESTS):
	print "No manifests."
	exit()

with open("manifest.xml.head") as fp:
	HEAD = fp.read()
	fp.close()

with open("manifest.xml.tail") as fp:
	TAIL = fp.read()
	fp.close()

with open("split_blacklist.txt", "r") as fp:
	BLACKLISTS = [line.rstrip() for line in fp.readlines()]
	fp.close()


for MANIFEST in MANIFESTS:
	KERNEL_MANIFEST = MANIFEST.replace(".xml", "_kernels.xml")
	DEVICE_MANIFEST = MANIFEST.replace(".xml", "_devices.xml")

	fp = open(MANIFEST, "r")

	DEVICES = []
	KERNELS = []
	DEFAULT = []

	for line in fp.readlines():
		next = False
		for BLACKLIST in BLACKLISTS:
			if line.find(BLACKLIST) is not -1:
				DEFAULT.append(line)
				next = True
				break

		if next:
			continue

		if line.find(DEVICE_PATTERN) is not -1:
			DEVICES.append(line)
		elif KERNEL_PATTERN.search(line):
			KERNELS.append(line)
		else:
			DEFAULT.append(line)

	fp.close()

	with open(KERNEL_MANIFEST, "w") as fp:
		fp.write(HEAD)
		fp.write("".join(KERNELS))
		fp.write(TAIL)

		fp.close()

	with open(DEVICE_MANIFEST, "w") as fp:
		fp.write(HEAD)
		fp.write("".join(DEVICES))
		fp.write(TAIL)
		fp.close()

	with open(MANIFEST, "w") as fp:
		fp.write("".join(DEFAULT))
		fp.close()

