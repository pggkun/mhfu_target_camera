.psp

PLAYER_COORDINATES equ 0x090AF0B0
MONSTER_POINTER equ 0x09C0D3C0
MOD_TRIGGER equ 0x0891C910
SELECTED equ 0x0891C908
PLAYER_AREA equ 0x09A40C38

.macro lio,reg, value
    lui   reg, (value >> 16)
	ori   reg, reg, (value & 0xFFFF)
.endmacro

.createfile "./bin/TARGET_CAM_JP.bin", 0x0891C920
	addiu		sp, sp, -0x18
	sv.q		c000, 0x8(sp)
	sw			ra, 0x4(sp)

	li	$t1, MOD_TRIGGER
	lw      $t2, 0($t1)
	lio	$t3, 0xFFFFFFFF
	bne	$t2, $t3, no_monster

	lui   t0, (PLAYER_COORDINATES >> 16)
	ori   t0, t0, (PLAYER_COORDINATES & 0xFFFF)
	lv.s  S000, 0(t0)
	lv.s  S001, 8(t0)

	li			t1, SELECTED 
	lw			t0, 0(t1) 

	lw			t6, 0(t0) 
	beq   		t6, zero, no_monster
	nop

	move		t0, t6 
	addiu		t0, t0, 0x29A 
	lb			t3, 0(t0) 

	lio			t4, PLAYER_AREA
	lb			t5, 0(t4)

	bne   		t3, t5, no_monster
	nop

	lw		t1, 0x40(t6)

	lv.s  S002, 0x40(t6)
	lv.s  S003, 0x48(t6)

	vsub.p		c000, c002, c000

	vmul.p		c002, c000, c000
	vfad.p		r020, c002  ; r020 = s003
	vsqrt.s		s003, s003
	vdiv.s		s003, s000, s003
	vasin.s		s003, s003

	lui			a3, 0x880
	
	li		  t0, 0x3F22F983
	mtv		 t0, S002

	vdiv.s		s003, s003, s002
	vsgn.s		s001, s001
	vmul.s		s003, s003, s001
	
	li		  t0, 0x40490fdb
	mtv		 t0, S002
	vadd.s		s003, s003, s002
	li		  t0, 0x00000000
	mtv		 t0, S002
	vsge.s		s000, s001, s002
	
	li		  t0, 0x40490fdb
	mtv		 t0, S002
	vmul.s		s002, s000, s002
	vadd.s		s003, s003, s002
	
	li		  t0, 0x4a22f983
	mtv		 t0, S002
	vmul.s		s003, s003, s002
	vf2in.s		s000, s003, 0x0

	sv.s		s000, 0x0(sp)

	li			t7,0x0
	lwr			t7,0x2(sp)
	sll			t7,t7,0x8
	lwr			t7,0x3(sp)
	lwl			t6,0x2(sp)
	lwl			t6,0x0(sp)
	lui			t5,0xFFFF
	and			t6,t6,t5
	li			t5,0xFFFF
	and			t7,t7,t5
	or			v0,t6,t7

	lui   t0, 0x0999
	ori   t0, t0, 0x8F00
	sh	v0, 0(t0)
	move a0, v0
	j 	ret
	nop

no_monster:
	lw	a0,0x1F4(s3)
ret:
	lw			ra, 0x4(sp)
	addiu		ra, ra, 0xC
	lv.q		c000, 0x8(sp)
	addiu		sp, sp, 0x18
	j 0x088871fc
.close