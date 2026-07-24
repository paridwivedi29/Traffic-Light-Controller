.globl main
# --- LED Memory Map ---
.equ N_RED, 0xf000002c
.equ N_YELLOW, 0xf0000030
.equ N_STRAIGHT, 0xf0000034
.equ N_LEFT, 0xf0000038
.equ N_RIGHT, 0xf000003c
.equ E_RED, 0xf0000118
.equ E_YELLOW, 0xf00000f4
.equ E_STRAIGHT, 0xf00000d0
.equ E_LEFT, 0xf00000ac

.equ E_RIGHT, 0xf0000088
.equ S_RED, 0xf000014c
.equ S_YELLOW, 0xf0000150
.equ S_STRAIGHT, 0xf0000154
.equ S_LEFT, 0xf0000158
.equ S_RIGHT, 0xf000015c
.equ W_RED, 0xf0000070
.equ W_YELLOW, 0xf0000094
.equ W_STRAIGHT, 0xf00000b8
.equ W_LEFT, 0xf00000dc
.equ W_RIGHT, 0xf0000100
# --- Colors ---
.equ RED, 0xFF0000
.equ YELLOW, 0xFFFF00
.equ GREEN, 0x00FF00
.equ OFF, 0x000000
.equ colour, 0xFFFFFF
# --- Timings ---
.equ GREEN_TIME, 150000
.equ YELLOW_TIME, 20000
main:
# Load all LED addresses into x registers
li x5, N_RED # x5 = N_RED
li x6, N_YELLOW # x6 = N_YELLOW
li x7, N_STRAIGHT # x7 = N_STRAIGHT
li x8, N_LEFT # x8 = N_LEFT
li x9, N_RIGHT # x9 = N_RIGHT
li x10, E_RED # x10 = E_RED
li x11, E_YELLOW # x11 = E_YELLOW
li x12, E_STRAIGHT # x12 = E_STRAIGHT
li x13, E_LEFT # x13 = E_LEFT
li x14, E_RIGHT # x14 = E_RIGHT
li x15, S_RED # x15 = S_RED
li x16, S_YELLOW # x16 = S_YELLOW
li x17, S_STRAIGHT # x17 = S_STRAIGHT
li x18, S_LEFT # x18 = S_LEFT
li x19, S_RIGHT # x19 = S_RIGHT
li x20, W_RED # x20 = W_RED
li x21, W_YELLOW # x21 = W_YELLOW
li x22, W_STRAIGHT # x22 = W_STRAIGHT
li x23, W_LEFT # x23 = W_LEFT
li x24, W_RIGHT # x24 = W_RIGHT
# Initialize all LEDs to OFF
jal x1, all_off
# Fill all other LEDs with colour
jal x1, fill_colour
# Start: all red initially
li x25, RED
sw x25, 0(x5) # N_RED
sw x25, 0(x10) # E_RED
sw x25, 0(x15) # S_RED
sw x25, 0(x20) # W_RED
main_loop:
# PHASE 1: South (straight + left + right) + East left
# Turn OFF red for South and East

li x25, OFF
sw x25, 0(x15) # S_RED off
sw x25, 0(x10) # E_RED off
# South: All movements green (straight + left + right)
li x25, GREEN
sw x25, 0(x17) # S_STRAIGHT
sw x25, 0(x18) # S_LEFT
sw x25, 0(x19) # S_RIGHT
# East: Only left turn green (straight and right are RED)
sw x25, 0(x13) # E_LEFT
li x25, RED
sw x25, 0(x12) # E_STRAIGHT red
sw x25, 0(x14) # E_RIGHT red
# All other directions remain red
li x25, RED
sw x25, 0(x5) # N_RED
sw x25, 0(x20) # W_RED
li x25, GREEN_TIME
jal x1, delay
# Yellow transition for Phase 1
li x25, YELLOW
sw x25, 0(x16) # S_YELLOW
sw x25, 0(x11) # E_YELLOW
li x25, YELLOW_TIME
jal x1, delay
# Turn OFF all greens, yellows, and red movement lights, turn ON red for South and East
li x25, OFF
sw x25, 0(x16) # S_YELLOW off
sw x25, 0(x11) # E_YELLOW off
sw x25, 0(x17) # S_STRAIGHT off
sw x25, 0(x18) # S_LEFT off
sw x25, 0(x19) # S_RIGHT off
sw x25, 0(x13) # E_LEFT off
sw x25, 0(x12) # E_STRAIGHT off (was red, now off)
sw x25, 0(x14) # E_RIGHT off (was red, now off)
li x25, RED
sw x25, 0(x15) # S_RED
sw x25, 0(x10) # E_RED
# PHASE 2: North (straight + left + right) + West left (mirror of phase 1)
# Turn OFF red for North and West
li x25, OFF
sw x25, 0(x5) # N_RED off
sw x25, 0(x20) # W_RED off
# North: All movements green (straight + left + right)
li x25, GREEN
sw x25, 0(x7) # N_STRAIGHT
sw x25, 0(x8) # N_LEFT
sw x25, 0(x9) # N_RIGHT
# West: Only left turn green (straight and right are RED)
sw x25, 0(x23) # W_LEFT
li x25, RED
sw x25, 0(x22) # W_STRAIGHT red
sw x25, 0(x24) # W_RIGHT red
# All other directions remain red
li x25, RED

sw x25, 0(x10) # E_RED
sw x25, 0(x15) # S_RED
li x25, GREEN_TIME
jal x1, delay
# Yellow transition for Phase 2
li x25, YELLOW
sw x25, 0(x6) # N_YELLOW
sw x25, 0(x21) # W_YELLOW
li x25, YELLOW_TIME
jal x1, delay
# Turn OFF all greens, yellows, and red movement lights, turn ON red for North and West
li x25, OFF
sw x25, 0(x6) # N_YELLOW off
sw x25, 0(x21) # W_YELLOW off
sw x25, 0(x7) # N_STRAIGHT off
sw x25, 0(x8) # N_LEFT off
sw x25, 0(x9) # N_RIGHT off
sw x25, 0(x23) # W_LEFT off
sw x25, 0(x22) # W_STRAIGHT off (was red, now off)
sw x25, 0(x24) # W_RIGHT off (was red, now off)
li x25, RED
sw x25, 0(x5) # N_RED
sw x25, 0(x20) # W_RED
# PHASE 3: East (straight + right + left) + North left (complementary flow)
# Turn OFF red for East and North
li x25, OFF
sw x25, 0(x10) # E_RED off
sw x25, 0(x5) # N_RED off
# East: All movements green (straight + right + left)
li x25, GREEN
sw x25, 0(x12) # E_STRAIGHT
sw x25, 0(x14) # E_RIGHT
sw x25, 0(x13) # E_LEFT
# North: Only left turn green (straight and right are RED)
sw x25, 0(x8) # N_LEFT
li x25, RED
sw x25, 0(x7) # N_STRAIGHT red
sw x25, 0(x9) # N_RIGHT red
# All other directions remain red
li x25, RED
sw x25, 0(x15) # S_RED
sw x25, 0(x20) # W_RED
li x25, GREEN_TIME
jal x1, delay
# Yellow transition for Phase 3
li x25, YELLOW
sw x25, 0(x11) # E_YELLOW
sw x25, 0(x6) # N_YELLOW
li x25, YELLOW_TIME
jal x1, delay
# Turn OFF all greens, yellows, and red movement lights, turn ON red for East and North
li x25, OFF
sw x25, 0(x11) # E_YELLOW off
sw x25, 0(x6) # N_YELLOW off

sw x25, 0(x12) # E_STRAIGHT off
sw x25, 0(x14) # E_RIGHT off
sw x25, 0(x13) # E_LEFT off
sw x25, 0(x8) # N_LEFT off
sw x25, 0(x7) # N_STRAIGHT off (was red, now off)
sw x25, 0(x9) # N_RIGHT off (was red, now off)
li x25, RED
sw x25, 0(x10) # E_RED
sw x25, 0(x5) # N_RED
# PHASE 4: West (straight + right + left) + South left (mirror of phase 3)
# Turn OFF red for West and South
li x25, OFF
sw x25, 0(x20) # W_RED off
sw x25, 0(x15) # S_RED off
# West: All movements green (straight + right + left)
li x25, GREEN
sw x25, 0(x22) # W_STRAIGHT
sw x25, 0(x24) # W_RIGHT
sw x25, 0(x23) # W_LEFT
# South: Only left turn green (straight and right are RED)
sw x25, 0(x18) # S_LEFT
li x25, RED
sw x25, 0(x17) # S_STRAIGHT red
sw x25, 0(x19) # S_RIGHT red
# All other directions remain red
li x25, RED
sw x25, 0(x5) # N_RED
sw x25, 0(x10) # E_RED
li x25, GREEN_TIME
jal x1, delay
# Yellow transition for Phase 4
li x25, YELLOW
sw x25, 0(x21) # W_YELLOW
sw x25, 0(x16) # S_YELLOW
li x25, YELLOW_TIME
jal x1, delay
# Turn OFF all greens, yellows, and red movement lights, turn ON red for West and South
li x25, OFF
sw x25, 0(x21) # W_YELLOW off
sw x25, 0(x16) # S_YELLOW off
sw x25, 0(x22) # W_STRAIGHT off
sw x25, 0(x24) # W_RIGHT off
sw x25, 0(x23) # W_LEFT off
sw x25, 0(x18) # S_LEFT off
sw x25, 0(x17) # S_STRAIGHT off (was red, now off)
sw x25, 0(x19) # S_RIGHT off (was red, now off)
li x25, RED
sw x25, 0(x20) # W_RED
sw x25, 0(x15) # S_RED
jal x0, main_loop
# All Off subroutine
all_off:
li x25, OFF
# North
sw x25, 0(x5)

sw x25, 0(x6)
sw x25, 0(x7)
sw x25, 0(x8)
sw x25, 0(x9)
# East
sw x25, 0(x10)
sw x25, 0(x11)
sw x25, 0(x12)
sw x25, 0(x13)
sw x25, 0(x14)
# South
sw x25, 0(x15)
sw x25, 0(x16)
sw x25, 0(x17)
sw x25, 0(x18)
sw x25, 0(x19)
# West
sw x25, 0(x20)
sw x25, 0(x21)
sw x25, 0(x22)
sw x25, 0(x23)
sw x25, 0(x24)
jalr x0, x1, 0
# Fill all other LEDs with coloursubroutine
fill_colour:
# Save return address
addi sp, sp, -4
sw x1, 0(sp)
li x25, colour
li x26, 0xf0000000 # Start address
li x27, 0xf000018c # End address (11x9 = 99 LEDs, 0xf0000000 + 99*4 = 0xf0000000 + 0x18C)
fill_loop:
# Check if current address is one of the traffic light addresses
# If yes, skip this address
beq x26, x5, skip_fill
beq x26, x6, skip_fill
beq x26, x7, skip_fill
beq x26, x8, skip_fill
beq x26, x9, skip_fill
beq x26, x10, skip_fill
beq x26, x11, skip_fill
beq x26, x12, skip_fill
beq x26, x13, skip_fill
beq x26, x14, skip_fill
beq x26, x15, skip_fill
beq x26, x16, skip_fill
beq x26, x17, skip_fill
beq x26, x18, skip_fill
beq x26, x19, skip_fill
beq x26, x20, skip_fill
beq x26, x21, skip_fill
beq x26, x22, skip_fill
beq x26, x23, skip_fill
beq x26, x24, skip_fill
# If not a traffic light address, fill with other colour
sw x25, 0(x26)
skip_fill:
addi x26, x26, 4
blt x26, x27, fill_loop
# Restore and return
lw x1, 0(sp)

addi sp, sp, 4
jalr x0, x1, 0
# Delay subroutine
delay:
# Save return address and delay value
addi sp, sp, -8
sw x1, 4(sp)
sw x25, 0(sp)
delay_loop:
lw x26, 0(sp)
addi x26, x26, -1
sw x26, 0(sp)
bne x26, x0, delay_loop
# Restore and return
lw x25, 0(sp)
lw x1, 4(sp)
addi sp, sp, 8
jalr x0, x1, 0
