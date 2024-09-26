macro bioscall num* {
    pusha
    int num
    popa
}

BIOS_VIDEO_SET_MODE equ 0x0
BIOS_VIDEO_WRITE_TELETYPE equ 0xE
BIOS_VIDEO_MODE_640x480x4 equ 0x12
BIOS_VIDEO_INT equ 0x10

org 0x7C00

xor ax, ax
jmp 0x0:set_cs
set_cs:
mov ss, ax
mov ds, ax
mov es, ax

mov bp, $$
mov sp, bp

jmp halt

halt:
cli
.loop:
hlt
jmp .loop

db 510 - ($ - $$) dup 0, 0x55, 0xAA

org 0x7E00

stage2:
jmp halt

db (512 - ($ mod 512)) mod 512 dup 0
stage2_size = $ - stage2
