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
```

## Build

```sh
just build
```
