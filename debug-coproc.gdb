# Connect to Core #1 target
target extended-remote :3334

# Load symbols from the Core #0 image (common ASM symbols are in this image, not the Core #1 image)
symbol-file lpc54114.elf

# Set PC to the reset value (this is not done automatically since we are not flashing the chip)
tbreak common_start
jump common_start

# Now load symbols from the coproc's actual code
symbol-file lpc54114-coproc.elf

# Continue to main
tbreak main
continue
