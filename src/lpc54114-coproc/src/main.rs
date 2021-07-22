#![no_main]
#![no_std]

#[cfg(not(debug_assertions))]
use panic_halt as _;
#[cfg(debug_assertions)]
use panic_semihosting as _;

use cortex_m::asm::wfi;
use cortex_m_rt::entry;
use cortex_m_semihosting::hprintln;

#[entry]
fn main() -> ! {
    let _ = hprintln!("Hello from the Cortex M0+!");

    loop {
        wfi();
    }
}
