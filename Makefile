all: build

build:
    fasm boot.asm

run:
    qemu-system-x86_64 -net none -drive file=boot.bin,format=raw

clean:
    rm -f boot.bin

.PHONY: all build run clean