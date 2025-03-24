.psp

BUTTON_L equ 0x00000100
BUTTON_DPAD_RIGHT equ 0x00000020
BUTTON_DPAD_LEFT equ 0x00000080
SELECTED equ 0x08800C00
TRIGGER equ 0x08800C04
BUTTONS_ADDR equ 0x08A5DD38
MONSTER_POINTER equ 0x09C0D3C0
PLAYER_AREA equ 0x090AF41A

.include "./src/gpu_macros.asm"

icon_x equ 0
icon_y equ 225

.macro lio,reg, value
    lui   reg, (value >> 16)
	ori   reg, reg, (value & 0xFFFF)
.endmacro

.createfile "./bin/TARGET_CHANGE_JP.bin", 0x9FF7F40
    addiu		sp, sp, -0x18
	sv.q		c000, 0x8(sp)
	sw			ra, 0x4(sp)

    lio   t0, SELECTED 
    lw    t1, 0(t0)       
    bne   t1, $zero, check_pointer
    nop
  
    lio   t0, SELECTED
    lio   t1, 0x09C0D3C0
    sw    t1, 0(t0)

check_pointer:
    lio   t0, SELECTED 
    lw    t1, 0(t0) 
    lw    t2, 0(t1) 
    bne   t2, $zero, no_update_need 
    nop

    li    t4, 0x1  
    addi  t1, t1, 4

check_loop:
    lw    t2, 0(t1) 
    bne   t2, $zero, update_to_new 
    nop
    addi  t1, t1, 4
    addi  t4, t4, 1
    blt   t4, 4, check_loop
    nop
    j need_to_reset

update_to_new:
    lio   t0, SELECTED
    sw    t1, 0(t0)
    j no_update_need

need_to_reset:
    lio   t0, SELECTED
    lio   t1, 0x09C0D3C0
    sw    t1, 0(t0)

no_update_need:

    li   t0, BUTTONS_ADDR
    lw    t1, 0(t0)

    li   t2, BUTTON_L | BUTTON_DPAD_RIGHT
    and   t3, t1, t2
    beq   t3, t2, buttons_checked
    nop

    li   t2, BUTTON_L | BUTTON_DPAD_LEFT
    and   t3, t1, t2
    beq   t3, t2, buttons_checked
    nop

    lio   t0, TRIGGER
    lio   t1, 0x00000000
    sh    t1, 0(t0)

buttons_checked:

    lio   t0, TRIGGER
    lw    t1, 0(t0)
    lio   t2, 0xFAFA
    and   t3, t1, t2
    beq   t3, t2, ret
    nop

    li   t0, BUTTONS_ADDR
    lw    t1, 0(t0)

    li   t2, BUTTON_L | BUTTON_DPAD_RIGHT
    and   t3, t1, t2
    beq   t3, t2, set_right
    nop

    li   t2, BUTTON_L | BUTTON_DPAD_LEFT
    and   t3, t1, t2
    beq   t3, t2, set_left
    nop

    lio   t0, TRIGGER
    lio   t1, 0x00000000
    sh    t1, 0(t0)

    j     ret
    nop

set_right:
    lio   t0, TRIGGER
    lio   t1, 0xFAFA
    sh    t1, 0(t0)


    lio  t1, SELECTED
    lw   t0, 0(t1)  
    addiu t0, t0, 4  
    sw   t0, 0(t1)  


    j     ret
    nop

set_left:
    lio   t0, TRIGGER
    lio   t1, 0xFAFA
    sh    t1, 0(t0)

    lio  t1, SELECTED
    lw   t0, 0(t1)  
    addiu t0, t0, -4

    lio   t2, 0x09C0D3C0
    sltu  t3, t0, t2
    beq   t3, $zero, not_less
    nop
    j     ret
    nop

not_less:
    sw   t0, 0(t1)

    j     ret
    nop

ret:
    sh	a0,-0x22B6(v1)

    lio $t1, 0x88871F8   ; target cam is active
    lw $t2, 0($t1)       ; carrega o byte em $t2
    lio $t3, 0x8E6401F4         ; valor esperado
    beq $t2, $t3, skip_draw  ; se for diferente, pula
    nop
    

monster_icon:
    li			t1, SELECTED 
	lw			t0, 0(t1) 

	lw			t6, 0(t0) 
	beq   		t6, zero, skip_draw
	nop

    li $t0, 0x00B40024     
    li $t1, 0x08801600     
    sw $t0, 0($t1)         

    li $t0, 0x00089Ce6     
    li $t1, 0x08801604     
    sw $t0, 0($t1)         

    li $t0, 0x000000E4     
    li $t1, 0x08801608     
    sw $t0, 0($t1)         

    li $t0, 0x00D80048     
    li $t1, 0x0880160C     
    sw $t0, 0($t1)         

    li $t0, 0x002C9Ce6     
    li $t1, 0x08801610     
    sw $t0, 0($t1)         

    li $t0, 0x00000108     
    li $t1, 0x08801614     
    sw $t0, 0($t1)         

    li t0, SELECTED
    lw t1, 0(t0)
    lw t0, 0(t1)
    lb t1, 0x1e8(t0)

    beq t1, 0x4b, tigrex
    nop
    beq t1, 0x46, popo
    nop
    beq t1, 0x45, anteka
    nop
    beq t1, 0x13, vespoid
    nop
    ;beq t1, 0x23, giaprey
    ;nop
    ;beq t1, 0x3d, blango
    ;nop

    j check_monster

tigrex:
    li t0, 0x00B40000     ;uv start   
    li t1, 0x08801600    
    sw t0, 0(t1)

    li t0, 0x00D70023     ;uv end   
    li t1, 0x0880160C    
    sw t0, 0(t1)
    j check_monster

anteka:
    li t0, 0x00D800B4     ;uv start   
    li t1, 0x08801600    
    sw t0, 0(t1)

    li t0, 0x00FC00D8     ;uv end   
    li t1, 0x0880160C    
    sw t0, 0(t1)
    j check_monster

vespoid:
    li t0, 0x002400D8     ;uv start   
    li t1, 0x08801600    
    sw t0, 0(t1)

    li t0, 0x004800FC     ;uv end   
    li t1, 0x0880160C    
    sw t0, 0(t1)
    j check_monster

popo:
    li t0, 0x00D800D8     ;uv start   
    li t1, 0x08801600    
    sw t0, 0(t1)

    li t0, 0x00FC00FC     ;uv end   
    li t1, 0x0880160C    
    sw t0, 0(t1)
    j check_monster

check_monster:

	move		t0, t6 
	addiu		t0, t0, 0x29A 
	lb			t3, 0(t0) 

	lio			t4, PLAYER_AREA
	lb			t5, 0(t4)

	bne   		t3, t5, darken_icon
	nop

    li t0, 0xFFFF     ;light   
    li t1, 0x08801604    
    sh t0, 0(t1)

    li t0, 0xFFFF     ;light   
    li t1, 0x08801610    
    sh t0, 0(t1)

    j draw_crosshair

darken_icon:
    li t0, 0x9Ce6     ;dark   
    li t1, 0x08801604    
    sh t0, 0(t1)

    li t0, 0x9Ce6     ;dark   
    li t1, 0x08801610    
    sh t0, 0(t1)

draw_crosshair:
    li          a0, gpu_code
    li          a2, 0
    li          a3, 0
    jal         0x0890BC50; sceGeListEnQueue
    li          a1, 0x0

skip_draw:
    lw			ra, 0x4(sp)
	addiu		ra, ra, 0xC
	lv.q		c000, 0x8(sp)
	addiu		sp, sp, 0x18
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
    .word 0xA0197900 ; Texture address 0: low=1527a0
    .word 0xA8090100 ; Texture stride 0: 0x0100, address high=09
    .word 0xB8000809 ; Texture size 0: 256x256
    .word 0xC500FF03 ; Clut format: 00ff03 (ABGR 8888)
    .word 0xB01aa110 ; CLUT addr: low=1627b0
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
.close
