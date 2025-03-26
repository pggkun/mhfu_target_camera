.psp

BUTTON_L equ 0x00000100
BUTTON_DPAD_RIGHT equ 0x00000020
BUTTON_DPAD_LEFT equ 0x00000080
SELECTED equ 0x08800C00
TRIGGER equ 0x08800C04
BUTTONS_ADDR equ 0x08A5DD38
MONSTER_POINTER equ 0x09C0D3C0
.include "./src/gpu_macros.asm"

icon_x equ 0
icon_y equ 225

.macro lio,reg, value
    lui   reg, (value >> 16)
	ori   reg, reg, (value & 0xFFFF)
.endmacro

.createfile "./bin/TARGET_CHANGE_JP.bin", 0x9FF7F40
    sh	a0,-0x22B6(v1)

    li          a0, gpu_code
    li          a2, 0
    li          a3, 0
    jal         0x0890BC50; sceGeListEnQueue
    li          a1, 0x0

	j 0x0886940C
    nop

.align 0X10
gpu_code:
.word 0xC9000100 ; TexFunc 0 RGBA modulate
.word 0xC0000000 ; Tex map mode: uvgen=texcoords, uvproj=pos
.word 0xC7000000 ; TexWrap wrap s, wrap t
.word 0xC6000000 ; TexFilter min: nearest, mag: nearest
.word 0x10080000 ; BASE: high=08

.word 0xC2000001 ; TexMode swizzle, 0 levels, shared clut
.word 0xC3000005 ; TexFormat CLUT8
.word 0xA01527A0 ; Texture address 0: low=1527a0
.word 0xA8090100 ; Texture stride 0: 0x0100, address high=09
.word 0xB8000808 ; Texture size 0: 256x256
.word 0xC500FF03 ; Clut format: 00ff03 (ABGR 8888)
.word 0xB01627B0 ; CLUT addr: low=1627b0
.word 0xB1090000 ; CLUT addr: high=09
.word 0xC4000020 ; Clut load: 091627b0, 1024 bytes
.word 0xCB000000 ; TexFlush
.word 0x10080000 ; BASE: high=08
.word 0x1E000001 ; Texture map enable: 1
.word 0xC9000100 ; TexFunc 0 RGBA modulate
.word 0x50000001 ; Shade: 1 (gouraud)
.word 0x12800116 ; SetVertexType: through, u16 texcoords, ABGR 1555 colors, s16 positions
.word 0x10080000 ; BASE: high=08
vaddr       0x801600
.word 0x04060002 ; DRAW PRIM RECTANGLES: count= 2 vaddr= 08a88714
finish
end


;.word 0x00002000 ; NOP: data= 200000 
;.word 0xFFFF0800 ; NOP: data= 08ffff 
;.word 0x08000000 ; NOP: data= 000008
;.word 0x34005000 ; NOP: data= 500034  
;.word 0xFFFF3C00 ; NOP: data= 3cffff
;.word 0x38000000 ; NOP: data= 000038
;vertices:
;    vertex      104, 16, 0xFFFFFFFF, 16, 225, 0
;    vertex      118, 16, 0xFFFFFFFF, 31, 225, 0
;    vertex      104, 30, 0xFFFFFFFF, 16, 240, 0
;    vertex      118, 30, 0xFFFFFFFF, 31, 240, 0
.close

.createfile "./bin/VERTEX.bin", 0x8801600
.align 0x20
vertices:
;     v    |  u 
.word 0x00200000 ; NOP: data= 200000
;     x    |  ? 
.word 0x0008FFFF ; NOP: data= 08ffff
;     ?    |  y 
.word 0x000000C8 ; NOP: data= 000008

;     v    |  u 
.word 0x00500030 ; NOP: data= 500034
;     x    |  ? 
.word 0x003CFFFF ; NOP: data= 3cffff
;     ?    |  y 
.word 0x000000F8 ; NOP: data= 000038
.close