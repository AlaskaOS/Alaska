include "bios.inc"

org 0x7C00

mov bp, $$
mov sp, bp

jmp 0x0:clear_cs
clear_cs:
xor ax, ax
mov ss, ax
mov ds, ax
mov es, ax

mov [boot_drive], dl

mov ax, BIOS_VIDEO_SET_MODE shl 8 or BIOS_VIDEO_MODE_640x480x4
bioscall BIOS_VIDEO_INT

mov ax, BIOS_VIDEO_WRITE_TELETYPE shl 8 or 'A'
xor bx, bx
bioscall BIOS_VIDEO_INT

jmp halt

halt:
cli
.loop:
hlt
jmp .loop

boot_drive db 0

db 510 - ($ - $$) dup 0, 0x55, 0xAA ; MBR
