use std::env;
use std::fs;
use std::path::{Path, PathBuf};

use cc;

fn main() {
    let crate_root = PathBuf::from(env::var_os("CARGO_MANIFEST_DIR").unwrap());
    let ws_root = crate_root.parent().unwrap().parent().unwrap();
    let out_dir = PathBuf::from(env::var_os("OUT_DIR").unwrap());

    // Copy memory.x and link.x to output directory
    fs::copy(ws_root.join("memory.x"), out_dir.join("memory.x")).unwrap();
    fs::copy(crate_root.join("link.x"), out_dir.join("link.x")).unwrap();

    build_assembly(&crate_root, &ws_root, &out_dir);

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

// Builds the required assembly files (if any) for the crate
fn build_assembly(crate_root: &Path, ws_root: &Path, out_dir: &Path) {
    let coproc_image = ws_root.join("target").join("lpc54114-coproc.bin");
    fs::copy(&coproc_image, out_dir.join(&coproc_image.file_name().unwrap())).unwrap();
    println!("cargo:rerun-if-changed={}", coproc_image.display());

    let src_dir = crate_root.join("src");
    let asm_files = ["init.S", "coproc-image.S"]
        .iter()
        .map(|f| src_dir.join(f))
        .collect::<Vec<_>>();

    // Rerun if the source changes
    asm_files
        .iter()
        .for_each(|f| println!("cargo:rerun-if-changed={}", f.display()));

    // Compile the assembly files
    cc::Build::new()
        .include(out_dir)
        .files(asm_files)
        .compile("lpc54115-init");

    println!("cargo:rustc-link-lib={}", "lpc54115-init");
}
