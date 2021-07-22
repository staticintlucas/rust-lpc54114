#![no_main]
#![no_std]

#[cfg(not(debug_assertions))]
use panic_halt as _;
#[cfg(debug_assertions)]
use panic_semihosting as _;

use cortex_m::asm::wfi;
use cortex_m::iprintln;
use cortex_m_rt::entry;

#[entry]
fn main() -> ! {
    let mut peripherals = cortex_m::Peripherals::take().unwrap();
    iprintln!(&mut peripherals.ITM.stim[0], "Hello from the Cortex M4F!");

    loop {
        wfi();
    }
}
