use std::env;
use std::fs;
use std::path::PathBuf;

fn main() {
    let crate_root = PathBuf::from(env::var_os("CARGO_MANIFEST_DIR").unwrap());
    let ws_root = crate_root.parent().unwrap().parent().unwrap();
    let out_dir = PathBuf::from(env::var_os("OUT_DIR").unwrap());

    // Copy memory.x and link.x to output directory
    fs::copy(ws_root.join("memory.x"), out_dir.join("memory.x")).unwrap();
    fs::copy(crate_root.join("link.x"), out_dir.join("link.x")).unwrap();

    // Rerun the script if the linker scripts change
    println!(
        "cargo:rerun-if-changed={}",
        ws_root.join("memory.x").display()
    );
    println!(
        "cargo:rerun-if-changed={}",
        crate_root.join("link.x").display()
    );

    // Add OUT_DIR to the link search path so lld finds the linker scripts
    println!("cargo:rustc-link-search={}", out_dir.display());
}
