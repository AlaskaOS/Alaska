MBR_SIGNATURE equ 0x55, 0xAA

BIOS_VIDEO_SET_MODE equ 0x0
BIOS_VIDEO_WRITE_CHARACTER equ 0xE

BIOS_VIDEO_MODE_80x25x4 equ 0x3

BIOS_VIDEO_INT equ 0x10

BIOS_DRIVE_READ equ 0x2

BIOS_DRIVE_INT equ 0x13

VGA_COLOR_BLACK equ 0x0
VGA_COLOR_TEAL equ 0x3
VGA_COLOR_WHITE equ 0xF

org 0x7C00

; entry
jmp 0x0:@f
@@:
xor ax, ax
mov ss, ax
mov ds, ax
mov es, ax

mov bp, $$
mov sp, bp

mov [boot_drive], dl

cld
sti

; https://stanislavs.org/helppc/int_13-2.html
pusha
mov ax, BIOS_DRIVE_READ shl 8 or (stage2.size / 512)
mov cx, 0 shl 8 or 2
movzx dx, [boot_drive]
mov bx, stage2
int BIOS_DRIVE_INT
popa
jnc stage2

jmp halt

halt:
cli
.loop:
hlt
jmp .loop

boot_drive db 0

db 510 - ($ - $$) dup 0, MBR_SIGNATURE

stage2:

; https://stanislavs.org/helppc/int_10-0.html
pusha
mov ax, BIOS_VIDEO_SET_MODE shl 8 or \
	BIOS_VIDEO_MODE_80x25x4
int BIOS_VIDEO_INT
popa

; spam A
push es
mov ax, (VGA_COLOR_BLACK shl 4 or VGA_COLOR_TEAL) shl 8 or 'A'
mov cx, 80 - hw.size
mov bx, 0xB800
mov es, bx
mov di, 0x0
rep stosw
pop es

; say Hello, world!
push es
mov cx, hw.size
mov si, hw
mov bx, 0xB800
mov es, bx
mov di, (80 - hw.size) * 2
@@:
lodsb
xor ah, ah
or ah, VGA_COLOR_BLACK shl 4 or VGA_COLOR_TEAL
stosw
loop @b
pop es

mov eax, 0x0
cpuid

cli
mov word [9*4], keyboard_routine
mov word [9*4+2], 0x0
sti

end_loop:
hlt
jmp end_loop

jmp halt

keyboard_routine:
push ax
in al, 0x60

test al, 0x80
jne .end

mov ah, BIOS_VIDEO_WRITE_CHARACTER
int BIOS_VIDEO_INT

.end:
mov al, 0x20
out 0x20, al
pop ax
iret

last_key_pressed db 'W'
hw db "Hello, world!"
hw.size = $ - hw

db (512 - ($ - stage2) mod 512) mod 512 dup 0
stage2.size = $ - stage2
