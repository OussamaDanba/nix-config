{ pkgs ? import <nixpkgs> { } }:

{
  pkgs = [ pkgs.cargo pkgs.rustc pkgs.rustfmt pkgs.sccache pkgs.clippy ];

  sessionVariables = {
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
  };
}
