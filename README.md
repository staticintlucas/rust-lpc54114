# Rust LPC54114

## Install dependencies

```sh
# Add compilation targets for the Cortex M0+ and M4F procs
rustup target add thumbv6m-none-eabi thumbv7em-none-eabihf
# Add LLVM versions of binutils
rustup component add llvm-tools-preview
# Install Cargo wrappers for binutils' tools
cargo install cargo-binutils
# Install Just, our build script runner
cargo install just
# Install arm-none-eabi-gcc to build assembly files
apt install gcc-arm-none-eabi
# Install pyocd debugger and GDB
python3 -m pip install -U pyocd
apt install gdb-multiarch
```

## Build

```sh
just build
```

## Debugging

### Start the GDB server

```sh
just start-gdb
```

### Launch Cortex M4F

```sh
gdb -x debug.gdb
```

Note: If you don't have `gdb-multiarch`, you can also use `arm-none-eabi-gdb`

### Launch Cortex M0+ coprocessor

```sh
gdb -x debug-coproc.gdb
```

Note: you need to launch the M4F first as it is responsible for flashing the elf image, copying the
coprocessor's code into RAM, and pulling the M0+ out of reset.
