#include "lpc54114.h"

    .syntax unified

    .thumb
    .arch   armv6s-m                    @ Use v6-m for common code, both cores can run it

    .section .text, "ax"
    .global common_start
    .type   common_start, %function
    .thumb_func

/******************************************************************************/
/* Reset vector for both cores                                                */
/*                                                                            */
/* Detects which core is executing the code and branches to the appropriate   */
/* start routine.                                                             */
/*                                                                            */
/* The M4F core will initialise RAM. It will copy its DATA section's initial  */
/* values into RAM and zero BSS, then copy the coprocessor image into RAM.    */
/* It will set the CPBOOT and CPSTACK registers for the coprocessor and reset */
/* it. Finally, it will initialise its FPU and continue to main.              */
/*                                                                            */
/* The M0+ core will check the CPBOOT and CPSTACK registers. If set, it will  */
/* use those as the address of its entry point, else it will sleep waiting    */
/* for the M4F to reset it after setting CPBOOT and CPSTACK.                  */
/******************************************************************************/

common_start:
    ldr     r0, =CPUID_ADDR             @ load CPUID register
    ldr     r0, [r0]
    ldr     r1, =PARTNO_MASK            @ mask PARTNO bits
    ands    r0, r1
    ldr     r1, =PARTNO_M4_VAL
    cmp     r0, r1                      @ if PARTNO == M4 => jump to m4_start
    beq     m4_start

m0_start:
    ldr     r0, =CPBOOT_ADDR            @ load CPBOOT value
    ldr     r0, [r0]
    cmp     r0, #0                      @ if CPBOOT == 0 wait for M4 to set it => jump to loop
    beq     1f
    ldr     r1, =CPSTACK_ADDR           @ load SP from CPSTACK
    ldr     r1, [r1]
    mov     sp, r1
    bx      r0                          @ jump to CPBOOT
1:
    wfi                                 @ loop forever until M4 resets us
    b       1b


    .thumb
    .arch   armv7e-m                    @ code used only by M4, can use v7e-m

m4_start:

en_sram:
    ldr     r0, =AHBCLKCTRLSET0_ADDR    @ r0 = AHBCLKCTRLSET0 address
    ldr     r1, =(AHBCLKCTRL0_SRAM1|AHBCLKCTRL0_SRAM2)  @ Enable all SRAMs
    str     r1, [r0]

init_cp_image:
    /* Here we load the current value of the CPUCTRL register. This is ORed   */
    /* with the write constant (a constant value that must be written to the  */
    /* upper half word for the write to take effect). We only use these later */
    /* in one of two places, but we load them here to avoid duplicate code. */
    ldr     r7, =CPUCTRL_ADDR           @ r7 = CPUCTRL address
    ldr     r6, [r7]                    @ r6 = current value of CPUCTRL
    ldr     r5, =CPUCTRL_WRITE
    orr     r6, r5                      @ r6 = current value | write constant

    /* Note: assumes start and end addresses are word aligned */
    ldr     r3, =__sicpimage            @ start addr of CP IMAGE in FLASH
    ldr     r1, =__scpimage             @ start addr of CP IMAGE in RAM
    ldr     r2, =__ecpimage             @ end addr of CP IMAGE in RAM
    subs    r2, r1                      @ r2 = r2 - r1 = len(IMAGE)

    /* if there is no CP image we disable the CP's clock for power saving */
    ittt    le                          @ if len(IMAGE) == 0
    bicle   r6, CPUCTRL_CP_CLKEN        @ DISABLE CP clock by clearing bit
    strle   r6, [r7]                    @ And write back to CPUCTRL
    ble     jmp_start                   @ skip copy

    /* Copy the image */
1:
    subs    r2, #4                      @ r2 = r2 - 4 (index of last word)
    ldr     r0, [r3, r2]
    str     r0, [r1, r2]
    bgt     1b                          @ do while(r2 > 0)

    /* Set the CPSTACK and CPBOOT registers for the CP */
    @ ldr     r1, =__cp_image_start__     @ start addr of CP IMAGE in RAM - r1 still has this value
    ldr     r0, =CPSTACK_ADDR
    ldr     r2, [r1]                    @ initial SP address, first word in the vector table
    str     r2, [r0]
    ldr     r0, =CPBOOT_ADDR
    ldr     r2, [r1, #4]                @ reset vector, i.e. initial PC address at offset 4
    str     r2, [r0]

jmp_start:
    /* Reset the CP so it boots to the freshly copied image */
    orr     r6, CPUCTRL_CP_RST          @ Set reset bit
    str     r6, [r7]
    bic     r6, CPUCTRL_CP_RST          @ Clear reset
    str     r6, [r7]
    b       Reset
