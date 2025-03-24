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

    beq t1, 16, velociprey
    nop
    

    beq t1, 13, genprey
    nop
    

    beq t1, 30, ioprey
    nop
    

    beq t1, 27, velocidrome
    nop
    

    beq t1, 28, gendrome
    nop
    

    beq t1, 31, iodrome
    nop
    

    beq t1, 3, kelbi
    nop
    

    beq t1, 6, kut_ku
    nop
    

    beq t1, 38, blue_kut_ku
    nop
    

    beq t1, 20, gypceros
    nop
    

    beq t1, 39, purple_gypceros
    nop
    

    beq t1, 8, cephadrome
    nop
    

    beq t1, 34, cephalos
    nop
    

    beq t1, 21, plesioth
    nop
    

    beq t1, 46, green_plesioth
    nop
    

    beq t1, 11, rathalos
    nop
    

    beq t1, 49, azure_rathalos
    nop
    

    beq t1, 41, silver_rathalos
    nop
    

    beq t1, 1, rathian
    nop
    

    beq t1, 37, pink_rathian
    nop
    

    beq t1, 42, gold_rathian
    nop
    

    beq t1, 19, vespoid
    nop
    

    beq t1, 80, vespoid_queen
    nop
    

    beq t1, 15, khezu
    nop
    

    beq t1, 45, red_khezu
    nop
    

    beq t1, 17, gravios
    nop
    

    beq t1, 47, black_gravios
    nop
    

    beq t1, 22, basarios
    nop
    

    beq t1, 26, monoblos
    nop
    

    beq t1, 44, white_monoblos
    nop
    

    beq t1, 14, diablos
    nop
    

    beq t1, 43, black_diablos
    nop
    

    beq t1, 33, kirin
    nop
    

    beq t1, 24, hornetaur
    nop
    

    beq t1, 7, lao_shan_lung
    nop
    

    beq t1, 50, ashen_lao_shan_lung
    nop
    

    beq t1, 78, yian_garuga
    nop
    

    beq t1, 40, one_ear_yian_garuga
    nop
    

    beq t1, 5, bulfango
    nop
    

    beq t1, 68, bulldrome
    nop
    

    beq t1, 51, blangonga
    nop
    

    beq t1, 84, copper_blangonga
    nop
    

    beq t1, 56, great_thunderbug
    nop
    

    beq t1, 53, rajang
    nop
    

    beq t1, 89, furious_rajang
    nop
    

    beq t1, 25, apceros
    nop
    

    beq t1, 66, hermitaur
    nop
    

    beq t1, 48, daimyo_hermitaur
    nop
    

    beq t1, 86, plum_daimyo_hermitaur
    nop
    

    beq t1, 73, ceanataur
    nop
    

    beq t1, 67, shogun_ceanataur
    nop
    

    beq t1, 87, terra_shogun_ceanataur
    nop
    

    beq t1, 54, kushala
    nop
    

    beq t1, 60, rusted_kushala
    nop
    

    beq t1, 59, chameleos
    nop
    

    beq t1, 64, lunastra
    nop
    

    beq t1, 65, teostra
    nop
    

    beq t1, 12, aptonoth
    nop
    

    beq t1, 75, tigrex
    nop
    

    beq t1, 52, congalala
    nop
    

    beq t1, 85, emerald_congalala
    nop
    

    beq t1, 61, blango
    nop
    

    beq t1, 62, conga
    nop
    

    beq t1, 9, felyne
    nop
    

    beq t1, 23, melynx
    nop
    

    beq t1, 4, mosswine
    nop
    

    beq t1, 35, giaprey
    nop
    

    beq t1, 77, giadrome
    nop
    

    beq t1, 63, remobra
    nop
    

    beq t1, 69, anteka
    nop
    

    beq t1, 70, popo
    nop
    

    beq t1, 83, lavasioth
    nop
    

    beq t1, 82, hypnocatrice
    nop
    

    beq t1, 72, yamatsukami
    nop
    

    beq t1, 57, shakalaka
    nop
    

    beq t1, 55, shengaoren
    nop
    

    beq t1, 81, nargacuga
    nop
    

velociprey:
        li t0, 0x00000000     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00240024     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

genprey:
        li t0, 0x00000024     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00240048     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

ioprey:
        li t0, 0x00000048     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x0024006C     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

velocidrome:
        li t0, 0x0000006C     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00240090     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

gendrome:
        li t0, 0x00000090     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x002400B4     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

iodrome:
        li t0, 0x000000B4     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x002400D8     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

kelbi:
        li t0, 0x000000D8     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x002400FC     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

kut_ku:
        li t0, 0x00240000     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00480024     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

blue_kut_ku:
        li t0, 0x00240000     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00480024     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

gypceros:
        li t0, 0x00240024     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00480048     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

purple_gypceros:
        li t0, 0x00240024     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00480048     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

cephadrome:
        li t0, 0x00240048     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x0048006C     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

cephalos:
        li t0, 0x00240048     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x0048006C     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

plesioth:
        li t0, 0x0024006C     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00480090     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

green_plesioth:
        li t0, 0x0024006C     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00480090     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

rathalos:
        li t0, 0x00240090     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x004800B4     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

azure_rathalos:
        li t0, 0x00240090     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x004800B4     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

silver_rathalos:
        li t0, 0x00240090     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x004800B4     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

rathian:
        li t0, 0x002400B4     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x004800D8     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

pink_rathian:
        li t0, 0x002400B4     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x004800D8     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

gold_rathian:
        li t0, 0x002400B4     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x004800D8     ;uv end   
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
    

vespoid_queen:
        li t0, 0x002400D8     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x004800FC     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

khezu:
        li t0, 0x00480000     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x006C0024     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

red_khezu:
        li t0, 0x00480000     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x006C0024     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

gravios:
        li t0, 0x00480024     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x006C0048     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

black_gravios:
        li t0, 0x00480024     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x006C0048     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

basarios:
        li t0, 0x00480048     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x006C006C     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

monoblos:
        li t0, 0x0048006C     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x006C0090     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

white_monoblos:
        li t0, 0x0048006C     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x006C0090     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

diablos:
        li t0, 0x00480090     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x006C00B4     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

black_diablos:
        li t0, 0x00480090     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x006C00B4     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

kirin:
        li t0, 0x004800B4     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x006C00D8     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

hornetaur:
        li t0, 0x004800D8     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x006C00FC     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

lao_shan_lung:
        li t0, 0x006C0000     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00900024     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

ashen_lao_shan_lung:
        li t0, 0x006C0000     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00900024     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

yian_garuga:
        li t0, 0x006C0024     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00900048     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

one_ear_yian_garuga:
        li t0, 0x006C0024     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00900048     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

bulfango:
        li t0, 0x006C0048     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x0090006C     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

bulldrome:
        li t0, 0x006C0048     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x0090006C     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

blangonga:
        li t0, 0x006C006C     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00900090     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

copper_blangonga:
        li t0, 0x006C006C     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00900090     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

great_thunderbug:
        li t0, 0x006C0090     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x009000B4     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

rajang:
        li t0, 0x006C00B4     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x009000D8     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

furious_rajang:
        li t0, 0x006C00B4     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x009000D8     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

apceros:
        li t0, 0x006C00D8     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x009000FC     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

hermitaur:
        li t0, 0x00900000     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00B40024     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

daimyo_hermitaur:
        li t0, 0x00900000     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00B40024     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

plum_daimyo_hermitaur:
        li t0, 0x00900000     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00B40024     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

ceanataur:
        li t0, 0x00900024     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00B40048     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

shogun_ceanataur:
        li t0, 0x00900024     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00B40048     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

terra_shogun_ceanataur:
        li t0, 0x00900024     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00B40048     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

kushala:
        li t0, 0x00900048     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00B4006C     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

rusted_kushala:
        li t0, 0x00900048     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00B4006C     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

chameleos:
        li t0, 0x0090006C     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00B40090     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

lunastra:
        li t0, 0x00900090     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00B400B4     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

teostra:
        li t0, 0x009000B4     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00B400D8     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

aptonoth:
        li t0, 0x009000D8     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00B400FC     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

tigrex:
        li t0, 0x00B40000     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00D80024     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

congalala:
        li t0, 0x00B40048     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00D8006C     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

emerald_congalala:
        li t0, 0x00B40048     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00D8006C     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

blango:
        li t0, 0x00B40090     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00D800B4     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

conga:
        li t0, 0x00B400B4     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00D800D8     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

felyne:
        li t0, 0x00B400D8     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00D800FC     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

melynx:
        li t0, 0x00D80000     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00FC0024     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

mosswine:
        li t0, 0x00D80024     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00FC0048     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

giaprey:
        li t0, 0x00D80048     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00FC006C     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

giadrome:
        li t0, 0x00D8006C     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00FC0090     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

remobra:
        li t0, 0x00D80090     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00FC00B4     ;uv end   
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
    

popo:
        li t0, 0x00D800D8     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x00FC00FC     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

lavasioth:
        li t0, 0x00FC0000     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x01200024     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

hypnocatrice:
        li t0, 0x00FC0024     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x01200048     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

yamatsukami:
        li t0, 0x00FC0048     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x0120006C     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

shakalaka:
        li t0, 0x00FC006C     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x01200090     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

shengaoren:
        li t0, 0x00FC0090     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x012000B4     ;uv end   
        li t1, 0x0880160C    
        sw t0, 0(t1)
        j check_monster
    

nargacuga:
        li t0, 0x00FC00B4     ;uv start   
        li t1, 0x08801600    
        sw t0, 0(t1)

        li t0, 0x012000D8     ;uv end   
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
    .word 0xB8000908 ; Texture size 0: 512x256
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
