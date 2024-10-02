org 0x7C00

clear_segments:
jmp 0x0:.set_cs
.set_cs:
xor ax, ax
mov ss, ax
mov es, ax
mov ds, ax

mov bp, $$
mov sp, bp

mov [boot_drive], dl

mov ax, 0x0 shl 8 or 0x3
int 0x10

push es
mov ax, 0xB800
mov es, ax

mov ax, 0x0F shl 8 or 'A'
mov cx, 80
mov di, 0
rep stosw

pop es

cli
lgdt [gdt_descriptor]

mov eax, cr0
or al, 1
mov cr0, eax

reload_segments:
jmp 0x8:.set_cs
.set_cs:
mov ax, 0x10
mov ss, ax
mov es, ax
mov ds, ax
mov gs, ax
mov fs, ax

use32
mov [0xB8000], word 0xDF shl 8 or 'R'
jmp halt
use16

halt:
cli
.loop:
hlt
jmp .loop

gdt:
.0 dq 0
.1.limit0 dw 0xFFFF
.1.base0 dw 0
.1.base1 db 0
.1.access db 10011010b
.1.flags_limit1 db 1100b shl 4 or 0xF
.1.base2 db 0
.2.limit0 dw 0xFFFF
.2.base0 dw 0
.2.base1 db 0
.2.access db 10010010b
.2.flags_limit1 db 1100b shl 4 or 0xF
.2.base2 db 0
.end = $

gdt_descriptor:
.size dw gdt.end - gdt
.offset dd gdt

boot_drive db 0

db 510 - ($ - $$) dup 0, 0x55, 0xAA
