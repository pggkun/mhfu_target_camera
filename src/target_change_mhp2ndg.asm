.psp

BUTTON_L equ 0x00000100
BUTTON_DPAD_RIGHT equ 0x00000020
BUTTON_DPAD_LEFT equ 0x00000080
SELECTED equ 0x08800AA0
TRIGGER equ 0x08800AA4
BUTTONS_ADDR equ 0x08A5DD38
MONSTER_POINTER equ 0x09C0D3C0

.macro lio,reg, value
    lui   reg, (value >> 16)
	ori   reg, reg, (value & 0xFFFF)
.endmacro

.createfile "./bin/TARGET_CHANGE_JP.bin", 0x9FF7F40
    addiu		sp, sp, -0x18
	sv.q		c000, 0x8(sp)
	sw			ra, 0x4(sp)

    lio    t0, SELECTED 
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
    lw			ra, 0x4(sp)
	addiu		ra, ra, 0xC
	lv.q		c000, 0x8(sp)
	addiu		sp, sp, 0x18
	j 0x0886940C
    nop
.close