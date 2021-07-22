    .syntax unified

    .thumb
    .arch   armv7e-m

    .section .cpimage, "ax", %progbits
    .global __CPIMAGE
    .type __CPIMAGE, %object

    .align 4

__CPIMAGE:
    .incbin "lpc54114-coproc.bin"
