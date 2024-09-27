macro bioscall interrupt* {
	pusha
	int interrupt
	popa
}

BIOS_VIDEO_SET_MODE equ 0x0
BIOS_VIDEO_WRITE_TELETYPE equ 0xE

BIOS_VIDEO_MODE_640x480x4 equ 0x12

BIOS_VIDEO_INT equ 0x10
