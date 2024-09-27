boot.bin: x86/bios_bootloader.asm
	fasm $^ $@

run: boot.bin
	qemu-system-x86_64 -net none -monitor stdio -drive format=raw,file=boot.bin

clean:
	rm -f boot.bin

.PHONY: run clean
