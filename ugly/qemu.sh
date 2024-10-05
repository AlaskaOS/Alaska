#!/bin/sh

qemu-system-x86_64 \
	-m 4096 \
	-monitor stdio \
	-drive format=raw,file=boot.bin
