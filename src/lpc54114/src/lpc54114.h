/* Note: use only preprocessor directives and block comments in this header */
/* as it is included in assembly files */

#ifndef LPC54114_INIT_H
#define LPC54114_INIT_H

#define CPUID_ADDR          0xe000ed00  /* CPUID register address */
#define PARTNO_MASK         0x0000fff0  /* PARTNO bit mask in CPUID */
#define PARTNO_M4_VAL       0x0000c240  /* PARTNO value for Cortex-M4 (M0+ = 0x0000c600) */

#define CPUCTRL_ADDR        0x40000800  /* CPUCTRL reg address (used to en/disable & reset cores) */
#define CPUCTRL_WRITE       0xc0c40000  /* Must be written to CPUCTRL for write to take effect */
#define CPUCTRL_CP_CLKEN    0x00000008  /* Bit to ENABLE M0+ CLK */
#define CPUCTRL_CP_RST      0x00000020  /* Bit to put M0+ into RESET */

#define AHBCLKCTRLSET0_ADDR 0x40000220  /* AHBCLKCTRLSET0 reg address (sets bits in AHBCLKCTRL0 */
                                        /* which en/disables clocks to individual blocks) */
#define AHBCLKCTRL0_SRAM1   0x00000008  /* Enables SRAM1 */
#define AHBCLKCTRL0_SRAM2   0x00000010  /* Enables SRAM2 */

#define CPBOOT_ADDR         0x40000804  /* CPBOOT register address (coproc boot address) */
#define CPSTACK_ADDR        0x40000808  /* CPSTACK register address (coproc stack address) */

#endif /* LPC54114_INIT_H */
