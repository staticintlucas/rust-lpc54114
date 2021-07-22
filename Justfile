default:
    @just --list

build: build-coproc
    #!/usr/bin/env bash
    set -euxo pipefail

    cd src/lpc54114
    cargo build
    cargo objcopy -- -O elf32-littlearm ../../lpc54114.elf

build-coproc:
    #!/usr/bin/env bash
    set -euxo pipefail

    cd src/lpc54114-coproc
    cargo build
    cargo objcopy -- -O elf32-littlearm ../../lpc54114-coproc.elf
    cargo objcopy -- -O binary ../../target/lpc54114-coproc.bin

clean:
    cargo clean
    rm lpc54114-coproc.elf
    rm lpc54114.elf
