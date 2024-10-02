boot.bin: boot.asm
	fasm $< $@

run: boot.bin
	qemu-system-x86_64 -monitor stdio -m 2048 -drive file=$<,format=raw

clean:
	rm -f boot.bin

.PHONY: run clean
