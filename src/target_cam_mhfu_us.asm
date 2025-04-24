.psp

BUTTON_L equ 0x00000100
BUTTON_DPAD_RIGHT equ 0x00000020
BUTTON_DPAD_LEFT equ 0x00000080
BUTTON_DPAD_UP equ 0x00000010
BUTTON_DPAD_DOWN equ 0x00000040

SELECTED equ 0x0891C908; TODO: Replace -> free ram starting here: 0x0891F300
TRIGGER equ 0x0891C90C ; TODO: Replace
MOD_TRIGGER equ 0x0891C910 ; TODO: Replace
BUTTONS_ADDR equ 0x08A62D88 ; DONE
MONSTER_POINTER equ 0x09C12240 ;DONE
PLAYER_COORDINATES equ 0x090B34B0 ; DONE
PLAYER_AREA equ 0x09A45038 ; DONE

TIMER equ 0x0891C620 ; TODO: Replace

sceGeListEnQueue equ 0x0890E200 ; DONE

VERTEX_0 equ 0x0891C8F0 ; TODO: Replace
VERTEX_1 equ 0x0891C8F4 ; TODO: Replace
VERTEX_2 equ 0x0891C8F8 ; TODO: Replace
VERTEX_3 equ 0x0891C8FC ; TODO: Replace
VERTEX_4 equ 0x0891C900 ; TODO: Replace
VERTEX_5 equ 0x0891C904 ; TODO: Replace

VCROSS_0 equ 0x0891E2C0 ; TODO: Replace
CROSSHAIR_SRC equ 0x0891DDBC ; TODO: Replace
CROSSHAIR_DES equ 0x040E0000 ; TODO: Replace


.include "./src/gpu_macros.asm"

icon_x equ 30
icon_y equ 55

.macro lio,reg, value
	lui	reg, (value >> 16)
	ori	reg, reg, (value & 0xFFFF)
.endmacro


.createfile "./bin/TARGET_CAM_US.bin", 0x0891C920  ; TODO: Replace
	addiu	sp, sp, -0x18
	sv.q	c000, 0x8(sp)
	sw		ra, 0x4(sp)

	li		t1, MOD_TRIGGER
	lw		t2, 0(t1)
	lio		t3, 0xFFFFFFFF
	bne		t2, t3, no_monster
	nop

	lui		t0, (PLAYER_COORDINATES >> 16)
	ori		t0, t0, (PLAYER_COORDINATES & 0xFFFF)
	lv.s  	S000, 0(t0)
	lv.s  	S001, 8(t0)

	li		t1, SELECTED 
	lw		t0, 0(t1) 

	lw		t6, 0(t0) 
	beq		t6, zero, no_monster
	nop

	move	t0, t6 
	addiu	t0, t0, 0x29A 
	lb		t3, 0(t0) 

	lio		t4, PLAYER_AREA
	lb		t5, 0(t4)

	bne		t3, t5, no_monster
	nop

	lw		t1, 0x40(t6)

	lv.s  	S002, 0x40(t6)
	lv.s  	S003, 0x48(t6)

	vsub.p	c000, c002, c000

	vmul.p	c002, c000, c000
	vfad.p	r020, c002  ; r020 = s003
	vsqrt.s	s003, s003
	vdiv.s	s003, s000, s003
	vasin.s	s003, s003

	lui		a3, 0x880
	
	li		t0, 0x3F22F983
	mtv		t0, S002

	vdiv.s	s003, s003, s002
	vsgn.s	s001, s001
	vmul.s	s003, s003, s001
	
	li		t0, 0x40490fdb
	mtv		t0, S002
	vadd.s	s003, s003, s002
	li		t0, 0x00000000
	mtv		t0, S002
	vsge.s	s000, s001, s002
	
	li		t0, 0x40490fdb
	mtv		t0, S002
	vmul.s	s002, s000, s002
	vadd.s	s003, s003, s002
	
	li		t0, 0x4a22f983
	mtv		t0, S002
	vmul.s	s003, s003, s002
	vf2in.s	s000, s003, 0x0

	sv.s	s000, 0x0(sp)

	li		t7,0x0
	lwr		t7,0x2(sp)
	sll		t7,t7,0x8
	lwr		t7,0x3(sp)
	lwl		t6,0x2(sp)
	lwl		t6,0x0(sp)
	lui		t5,0xFFFF
	and		t6,t6,t5
	li		t5,0xFFFF
	and		t7,t7,t5
	or		v0,t6,t7

	move 	a0, v0
	j 		return
	nop

no_monster:
	lw		a0,0x1F4(s3)

return:
	li		t0, 30 
	li		t1, TIMER 
	sw		t0, 0(t1)

	lw		ra, 0x4(sp)
	addiu	ra, ra, 0xC
	lv.q	c000, 0x8(sp)
	addiu	sp, sp, 0x18
	j 		0x088874f8 ; DONE
.close

.createfile "./bin/VERTEX_US.bin", 0x0891E2C0  ; TODO: Replace
.align 0x10
vertices:
	vertex	0, 0, 0xFFFFFFCC, icon_x -16, icon_y -16, 0
	vertex	31, 31, 0xFFFFFFCC, icon_x + 16, icon_y + 16, 0
	vertex	31, 0, 0xFFFFFFCC, icon_x + 16, icon_y  - 16, 0

	vertex	0, 0, 0xFFFFFFCC, icon_x -16, icon_y -16, 0
	vertex	31, 31, 0xFFFFFFCC, icon_x + 16, icon_y + 16, 0
	vertex	0, 31, 0xFFFFFFCC, icon_x - 16, icon_y + 16, 0
.close

.createfile "./bin/TARGET_CHANGE_US.bin", 0x0891CAA0  ; TODO: Replace
	addiu	sp, sp, -0x18
	sv.q	c000, 0x8(sp)
	sw		ra, 0x4(sp)


	li		t0, CROSSHAIR_SRC
	li		t1, CROSSHAIR_DES

	lb		t3, 0x90(t1)
	bnez	t3, skip_copy
	nop

	li		t2, 264

copy_loop:
	lw		t3, 0(t0)
	sw		t3, 0(t1)
	addiu	t0, t0, 4
	addiu	t1, t1, 4
	addiu	t2, t2, -1
	bgtz	t2, copy_loop
	nop

skip_copy:
	lio		t1, TIMER
	lw		t2, 0(t1)
	beqz	t2, skip_subtract
	nop

	addi	t2, t2, -1
	sw		t2, 0(t1)
skip_subtract:

	li		t0, BUTTONS_ADDR
	lw		t1, 0(t0)

	li		t2, BUTTON_L | BUTTON_DPAD_UP
	and		t3, t1, t2
	beq		t3, t2, activate_mod
	nop

	li		t2, BUTTON_L | BUTTON_DPAD_DOWN
	and		t3, t1, t2
	beq		t3, t2, deactivate_mod
	nop

	j		mod_stay
	nop

activate_mod:
	li		t0, MOD_TRIGGER
	li		t1, 0xFFFFFFFF
	sw		t1, 0(t0)
	j		mod_stay
	nop

deactivate_mod:
	li		t0, MOD_TRIGGER
	li		t1, 0x00000000
	sw		t1, 0(t0)
	j		mod_stay
	nop

mod_stay:	
	lio		t0, SELECTED 
	lw		t1, 0(t0)	
	bne		t1, zero, check_pointer
	nop
	
	lio		t0, SELECTED
	lio		t1, 0x09C0D3C0  ; TODO: Replace
	sw		t1, 0(t0)

check_pointer:
	lio		t0, SELECTED 
	lw		t1, 0(t0) 
	lw		t2, 0(t1) 
	bne		t2, zero, no_update_need 
	nop

	li		t4, 0x1	
	addi	t1, t1, 4

check_loop:
	lw		t2, 0(t1) 
	bne		t2, zero, update_to_new 
	nop

	addi	t1, t1, 4
	addi	t4, t4, 1
	blt		t4, 4, check_loop
	nop
	j need_to_reset

update_to_new:
	lio		t0, SELECTED
	sw		t1, 0(t0)
	j		no_update_need

need_to_reset:
	lio		t0, SELECTED
	lio		t1, 0x09C0D3C0  ; TODO: Replace
	sw		t1, 0(t0)

no_update_need:

	li		t0, BUTTONS_ADDR
	lw		t1, 0(t0)

	li		t2, BUTTON_L | BUTTON_DPAD_RIGHT
	and		t3, t1, t2
	beq		t3, t2, buttons_checked
	nop

	li		t2, BUTTON_L | BUTTON_DPAD_LEFT
	and		t3, t1, t2
	beq		t3, t2, buttons_checked
	nop

	lio		t0, TRIGGER
	lio		t1, 0x00000000
	sh		t1, 0(t0)

buttons_checked:

	lio		t0, TRIGGER
	lw		t1, 0(t0)
	lio		t2, 0xFAFA
	and		t3, t1, t2
	beq		t3, t2, ret
	nop

	li		t0, BUTTONS_ADDR
	lw		t1, 0(t0)

	li		t2, BUTTON_L | BUTTON_DPAD_RIGHT
	and		t3, t1, t2
	beq		t3, t2, set_right
	nop

	li		t2, BUTTON_L | BUTTON_DPAD_LEFT
	and		t3, t1, t2
	beq		t3, t2, set_left
	nop

	lio		t0, TRIGGER
	lio		t1, 0x00000000
	sh		t1, 0(t0)

	j		ret
	nop

set_right:
	lio		t0, TRIGGER
	lio		t1, 0xFAFA
	sh		t1, 0(t0)

	lio		t1, SELECTED
	lw		t0, 0(t1)	
	addiu		t0, t0, 4	
	sw		t0, 0(t1)	

	j		ret
	nop

set_left:
	lio		t0, TRIGGER
	lio		t1, 0xFAFA
	sh		t1, 0(t0)

	lio		t1, SELECTED
	lw		t0, 0(t1)	
	addiu		t0, t0, -4

	lio		t2, 0x09C0D3C0  ; TODO: Replace
	sltu	t3, t0, t2
	beq		t3, zero, not_less
	nop

	j		ret
	nop

not_less:
	sw		t0, 0(t1)

	j		ret
	nop

ret:
	sh		a0,-0x22B6(v1)

	li		t1, MOD_TRIGGER
	lw		t2, 0(t1)
	lio		t3, 0xFFFFFFFF
	bne		t2, t3, skip_draw

	nop

monster_icon:
	;skip if loading
	li		t1, 0x090AF424  ; TODO: Replace
	lb		t0, 0(t1)
	bne		t0, 0x0, skip_draw

	;skip if paused
	li		t1, 0x09A01A8B  ; TODO: Replace
	lb		t0, 0(t1)
	bne		t0, 0x0, skip_draw

	;skip when mission failed
	li		t1, 0x09A01B1C  ; TODO: Replace
	lb		t0, 0(t1)
	beq		t0, 0xFFFFFFFF, skip_draw

	;skip if mission completed 
	li		t0, 0x09A02228 ; TODO: Replace
	lbu		t1, 0(t0)	
	li		t2, 0x30	
	slt		t3, t2, t1
	bne		t3, zero, check_dual_quest_end
	nop
	j skip_dual_test_check
	
check_dual_quest_end:
	li		t0, 0x09A02230 ; TODO: Replace 
	lbu		t1, 0(t0)
	beq		t1, 0x0, skip_draw
	nop

	li		t2, 0x30	
	slt		t3, t2, t1
	bne		t3, zero, skip_draw

skip_dual_test_check:
	li		t1, SELECTED 
	lw		t0, 0(t1) 

	lw		t6, 0(t0) 
	beq		t6, zero, skip_draw
	nop

	; setup vertices
	; monster icon
	li		t0, 0x00B40024	
	li		t1, VERTEX_0	
	sw		t0, 0(t1)	

	li		t0, 0x00089Ce6	
	li		t1, VERTEX_1	
	sw		t0, 0(t1)	

	li		t0, 0x000000E4	
	li		t1, VERTEX_2	
	sw		t0, 0(t1)	

	li		t0, 0x00D80048	
	li		t1, VERTEX_3	
	sw		t0, 0(t1)	

	li		t0, 0x002C9Ce6	
	li		t1, VERTEX_4	
	sw		t0, 0(t1)	

	li		t0, 0x00000108	
	li		t1, VERTEX_5	
	sw		t0, 0(t1)	

	li		t0, SELECTED
	lw		t1, 0(t0)
	lw		t0, 0(t1)
	lb		t1, 0x1e8(t0)

loop_start:
	li		t2, 0  ; list_counter

loop:
	li		t3, monster_list
	addu		t3, t3, t2
	addi		t2, t2, 8

	bgt		t2, 77 * 8, restore_unknown_icon
	nop

	lw		t4, 0(t3)
	bne		t1, t4, loop
	nop

loop_end:
	lw		t0, 4(t3)	;uv start	
	li		t1, VERTEX_0	
	sw		t0, 0(t1)

	andi	t2, t0, 0xFFFF
	addi	t2, t2, 36

	srl		t3, t0, 16
	andi	t3, t3, 0xFFFF
	addi	t3, t3, 36

	li		t1, VERTEX_3	
	sh		t3, 2(t1)
	sh		t2, 0(t1)
	j		check_monster

restore_unknown_icon:
	li		t0, 0x00B40024	
	li		t1, VERTEX_0	
	sw		t0, 0(t1)

	li		t0, 0x00D80048	
	li		t1, VERTEX_3	
	sw		t0, 0(t1)	

check_monster:

	move	t0, t6 
	addiu	t0, t0, 0x29A 
	lb		t3, 0(t0) 

	lio		t4, PLAYER_AREA
	lb		t5, 0(t4)

	bne		t3, t5, darken_icon
	nop

	;world to screen
	li		t1, SELECTED

	lw		t0, 0(t1)
	lw		t6, 0(t0)
	lw		t1, 0x40(t6)

	;cleaning matrix M500 and M600
	vzero.q c500
	vzero.q c510
	vzero.q c520
	vzero.q c530

	vzero.q	c600
	vzero.q	c610
	vzero.q	c620
	vzero.q	c630

	vone.q  c500
	lv.s	S500, 0x40(t6) ;input x

	lv.s	S501, 0x44(t6) ;input y
	li		t0, 0x42c80000 ; offset +100
	mtv		t0, s602
	vadd.s	S501, S501, s602
	
	lv.s	S502, 0x48(t6) ;input z

	;view @ position (using vdot because view matrix is transposed)
	vdot.q	c600, r100, c500
	vdot.q	c610, r101, c500
	vdot.q	c620, r102, c500
	vdot.q	c630, r103, c500

	;loading projection matrix values
	vzero.q	c500

	li		t0,	0x3f9b8c00
	mtv		t0, s500

	li		t0, 0x40093eff
	mtv		t0, s511

	li		t0, 0xbf800000
	mtv		t0, s522

	li		t0, 0xbf800000
	mtv		t0, s532

	li		t0, 0xc2700000
	mtv		t0, s523

	; projection @ (view @ position)
	vtfm4.q	r601, M500, r600

	;ndc
	vdiv.s	s602, s601, s631
	vdiv.s	s612, s611, s631
	vdiv.s	s622, s621, s631

	li		t0, 0x43f00000
	mtv		t0, s600

	li		t0, 0x43880000
	mtv		t0, s610

	li		t0, 0x3f000000
	mtv		t0, s620

	;ndc to screen coordinates
	vadd.s	s602, s602, s630
	vmul.s	s602, s602, s620
	vmul.s	s602, s602, s600 

	vsub.s	s612, s630, s612
	vmul.s	s612, s612, s620
	vmul.s	s612, s612, s610 

	vf2in.s  s602, s602, 0 ;result x
	vf2in.s  s612, s612, 0 ;result y

	mfv t0, s602
	mfv t1, s612

	blt		t0, 0 + 20, not_on_screen
	nop
	bgt		t0, 480 - 20, not_on_screen
	nop

	blt		t1, 0 + 20, not_on_screen
	nop
	bgt		t1, 272 - 20, not_on_screen
	nop

	li		t0, 0xAA 
	li		t1, TIMER
	sb		t0, 0x4(t1)
	j		on_screen;

not_on_screen:
	li		t0, 0xFF 
	li		t1, TIMER
	sb		t0, 0x4(t1)
	j		skip_crosshair
	nop

on_screen:
	;adjust x
	mfv		t0, s602
	addi	t0, t0, -16
	li		t1, VCROSS_0	
	sh		t0, 0x8(t1)

	mfv		t0, s602
	addi	t0, t0, 16
	li		t1, VCROSS_0	
	sh		t0, 0x18(t1)

	mfv		t0, s602
	addi	t0, t0, 16
	li		t1, VCROSS_0	
	sh		t0, 0x28(t1)

	mfv		t0, s602
	addi	t0, t0, -16
	li		t1, VCROSS_0	
	sh		t0, 0x38(t1)

	mfv		t0, s602
	addi	t0, t0, 16
	li		t1, VCROSS_0	
	sh		t0, 0x48(t1)

	mfv		t0, s602
	addi	t0, t0, -16
	li		t1, VCROSS_0	
	sh		t0, 0x58(t1)		

	;adjust y
	mfv		t0, s612
	addi	t0, t0, -16
	li		t1, VCROSS_0	
	sh		t0, 0xa(t1)

	mfv		t0, s612
	addi	t0, t0, 16
	li		t1, VCROSS_0	
	sh		t0, 0x1a(t1)

	mfv		t0, s612
	addi	t0, t0, -16	
	li		t1, VCROSS_0	
	sh		t0, 0x2a(t1)

	mfv		t0, s612
	addi	t0, t0, -16
	li		t1, VCROSS_0	
	sh		t0, 0x3a(t1)

	mfv		t0, s612
	addi		t0, t0, 16	
	li		t1, VCROSS_0	
	sh		t0, 0x4a(t1)

	mfv		t0, s612
	addi	t0, t0, 16
	li		t1, VCROSS_0	
	sh		t0, 0x5a(t1)

skip_crosshair:
	li		t0, 0xFFFF	;light	
	li		t1, VERTEX_1	
	sh		t0, 0(t1)

	li		t0, 0xFFFF	;light	
	li		t1, VERTEX_4	
	sh		t0, 0(t1)

	j		drawing

darken_icon:
	li		t0, 0xFF 
	li		t1, TIMER
	sb		t0, 0x4(t1)

	li		t0, 0x9Ce6	;dark	
	li		t1, VERTEX_1	
	sh		t0, 0(t1)

	li		t0, 0x9Ce6	;dark	
	li		t1, VERTEX_4	
	sh		t0, 0(t1)

drawing:
	li		a0, gpu_code
	li		a2, 0
	li		a3, 0
	jal		sceGeListEnQueue; 
	li		a1, 0x0

	lio		t1, TIMER
	lw		t2, 0(t1)
	beqz	t2, skip_draw
	nop

	li		t0, 0xFF
	lbu		t2, 4(t1)
	beq		t2, t0, skip_draw
	nop

	li		a0, gpu_code2
	li		a2, 0
	
	li		a3, 0
	jal		sceGeListEnQueue; 
	li		a1, 0x0

skip_draw:
	lw		ra, 0x4(sp)
	addiu	ra, ra, 0xC
	lv.q	c000, 0x8(sp)
	addiu	sp, sp, 0x18
	j		0x08869414 ; DONE
	nop

.align 0X10
gpu_code:
	.word	0xC9000100 ; TexFunc 0 RGBA modulate
	.word	0xC0000000 ; Tex map mode: uvgen=texcoords, uvproj=pos
	.word	0xC7000000 ; TexWrap wrap s, wrap t
	.word	0xC6000000 ; TexFilter min: nearest, mag: nearest
	.word	0x10080000 ; BASE: high=08

	.word	0xC2000001 ; TexMode swizzle, 0 levels, shared clut
	.word	0xC3000005 ; TexFormat CLUT8
	.word	0xA0197900 ; Texture address 0: low=1527a0  ; TODO: Replace
	.word	0xA8090100 ; Texture stride 0: 0x0100, address high=09  ; TODO: Replace
	.word	0xB8000908 ; Texture size 0: 512x256
	.word	0xC500FF03 ; Clut format: 00ff03 (ABGR 8888)
	.word	0xB01aa110 ; CLUT addr: low=1627b0  ; TODO: Replace
	.word	0xB1090000 ; CLUT addr: high=09  ; TODO: Replace
	.word	0xC4000020 ; Clut load: 091627b0, 1024 bytes
	.word	0xCB000000 ; TexFlush
	.word	0x10080000 ; BASE: high=08
	.word	0x1E000001 ; Texture map enable: 1
	.word	0xC9000100 ; TexFunc 0 RGBA modulate
	.word	0x50000001 ; Shade: 1 (gouraud)
	.word	0x12800116 ; SetVertexType: through, u16 texcoords, ABGR 1555 colors, s16 positions| vertex use 1280011E
	.word	0x10080000 ; BASE: high=08
	vaddr	VERTEX_0 - 0x08000000
	.word	0x04060002 ; DRAW PRIM RECTANGLES: count= 2 vaddr= 08a88714
	finish
	end

gpu_code2:
	.word	0xC2000000 ; TexMode linear
	.word	0xA00E0000 ; Texture address 0: low=9E0000 (CROSSHAIR_DES - 9000000)  ; TODO: Replace
	.word	0xA8040020 ; Texture stride 0: 0x0100, address high=04  ; TODO: Replace
	.word	0xB8000505 ; Texture size 0: 32x32
	.word	0xC500FF03 ; Clut format: 00ff03 (ABGR 8888)
	.word	0xB00E0400 ; CLUT addr: low=9E0400 (CROSSHAIR_DES + 0x400 -  0x9000000)  ; TODO: Replace
	.word	0xB1040000 ; CLUT addr: high=04  ; TODO: Replace
	.word	0xC4000020 ; Clut load: 091627b0, 1024 bytes
	.word	0xCB000000 ; TexFlush
	.word	0x10080000 ; BASE: high=08
	.word	0x1E000001 ; Texture map enable: 1
	.word	0xC9000100 ; TexFunc 0 RGBA modulate
	.word	0x50000001 ; Shade: 1 (gouraud)
	.word	0x1280011E ; SetVertexType: through, u16 texcoords, ABGR 8888 colors, s16 positions
	.word	0x10080000 ; BASE: high=08
	vaddr	VCROSS_0 - 0x08000000
	prim	3, 3
	prim	3, 3
	finish
	end

monster_list:
    ;velociprey
    .word 0x00000010
    .word 0x00000000
	;popo
    .word 0x00000046
    .word 0x00D800D8
    ;genprey
    .word 0x0000000D
    .word 0x00000024
    ;ioprey
    .word 0x0000001E
    .word 0x00000048
    ;velocidrome
    .word 0x0000001B
    .word 0x0000006C
    ;gendrome
    .word 0x0000001C
    .word 0x00000090
    ;iodrome
    .word 0x0000001F
    .word 0x000000B4
    ;kelbi
    .word 0x00000003
    .word 0x000000D8
    ;kut_ku
    .word 0x00000006
    .word 0x00240000
    ;blue_kut_ku
    .word 0x00000026
    .word 0x00240000
    ;gypceros
    .word 0x00000014
    .word 0x00240024
    ;purple_gypceros
    .word 0x00000027
    .word 0x00240024
    ;cephadrome
    .word 0x00000008
    .word 0x00240048
    ;cephalos
    .word 0x00000022
    .word 0x00240048
    ;plesioth
    .word 0x00000015
    .word 0x0024006C
    ;green_plesioth
    .word 0x0000002E
    .word 0x0024006C
    ;rathalos
    .word 0x0000000B
    .word 0x00240090
    ;azure_rathalos
    .word 0x00000031
    .word 0x00240090
    ;silver_rathalos
    .word 0x00000029
    .word 0x00240090
    ;rathian
    .word 0x00000001
    .word 0x002400B4
    ;pink_rathian
    .word 0x00000025
    .word 0x002400B4
    ;gold_rathian
    .word 0x0000002A
    .word 0x002400B4
    ;vespoid
    .word 0x00000013
    .word 0x002400D8
    ;vespoid_queen
    .word 0x00000050
    .word 0x002400D8
    ;khezu
    .word 0x0000000F
    .word 0x00480000
    ;red_khezu
    .word 0x0000002D
    .word 0x00480000
    ;gravios
    .word 0x00000011
    .word 0x00480024
    ;black_gravios
    .word 0x0000002F
    .word 0x00480024
    ;basarios
    .word 0x00000016
    .word 0x00480048
    ;monoblos
    .word 0x0000001A
    .word 0x0048006C
    ;white_monoblos
    .word 0x0000002C
    .word 0x0048006C
    ;diablos
    .word 0x0000000E
    .word 0x00480090
    ;black_diablos
    .word 0x0000002B
    .word 0x00480090
    ;kirin
    .word 0x00000021
    .word 0x004800B4
    ;hornetaur
    .word 0x00000018
    .word 0x004800D8
    ;lao_shan_lung
    .word 0x00000007
    .word 0x006C0000
    ;ashen_lao_shan_lung
    .word 0x00000032
    .word 0x006C0000
    ;yian_garuga
    .word 0x0000004E
    .word 0x006C0024
    ;one_ear_yian_garuga
    .word 0x00000028
    .word 0x006C0024
    ;bulfango
    .word 0x00000005
    .word 0x006C0048
    ;bulldrome
    .word 0x00000044
    .word 0x006C0048
    ;blangonga
    .word 0x00000033
    .word 0x006C006C
    ;copper_blangonga
    .word 0x00000054
    .word 0x006C006C
    ;great_thunderbug
    .word 0x00000038
    .word 0x006C0090
    ;rajang
    .word 0x00000035
    .word 0x006C00B4
    ;furious_rajang
    .word 0x00000059
    .word 0x006C00B4
    ;apceros
    .word 0x00000019
    .word 0x006C00D8
    ;hermitaur
    .word 0x00000042
    .word 0x00900000
    ;daimyo_hermitaur
    .word 0x00000030
    .word 0x00900000
    ;plum_daimyo_hermitaur
    .word 0x00000056
    .word 0x00900000
    ;ceanataur
    .word 0x00000049
    .word 0x00900024
    ;shogun_ceanataur
    .word 0x00000043
    .word 0x00900024
    ;terra_shogun_ceanataur
    .word 0x00000057
    .word 0x00900024
    ;kushala
    .word 0x00000036
    .word 0x00900048
    ;rusted_kushala
    .word 0x0000003C
    .word 0x00900048
    ;chameleos
    .word 0x0000003B
    .word 0x0090006C
    ;lunastra
    .word 0x00000040
    .word 0x00900090
    ;teostra
    .word 0x00000041
    .word 0x009000B4
    ;aptonoth
    .word 0x0000000C
    .word 0x009000D8
    ;tigrex
    .word 0x0000004B
    .word 0x00B40000
    ;congalala
    .word 0x00000034
    .word 0x00B40048
    ;emerald_congalala
    .word 0x00000055
    .word 0x00B40048
    ;blango
    .word 0x0000003D
    .word 0x00B40090
    ;conga
    .word 0x0000003E
    .word 0x00B400B4
    ;felyne
    .word 0x00000009
    .word 0x00B400D8
    ;melynx
    .word 0x00000017
    .word 0x00D80000
    ;mosswine
    .word 0x00000004
    .word 0x00D80024
    ;giaprey
    .word 0x00000023
    .word 0x00D80048
    ;giadrome
    .word 0x0000004D
    .word 0x00D8006C
    ;remobra
    .word 0x0000003F
    .word 0x00D80090
    ;anteka
    .word 0x00000045
    .word 0x00D800B4
    ;lavasioth
    .word 0x00000053
    .word 0x00FC0000
    ;hypnocatrice
    .word 0x00000052
    .word 0x00FC0024
    ;yamatsukami
    .word 0x00000048
    .word 0x00FC0048
    ;shakalaka
    .word 0x00000039
    .word 0x00FC006C
    ;shengaoren
    .word 0x00000037
    .word 0x00FC0090
    ;nargacuga
    .word 0x00000051
    .word 0x00FC00B4
.close
