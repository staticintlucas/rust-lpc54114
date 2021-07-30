# Connect to Core #0 target
target extended-remote :3333

# Load ELF image
file lpc54114.elf
load

# Continue to main
tbreak main
continue
