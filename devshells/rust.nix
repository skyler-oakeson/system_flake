{ pkgs, ... }:
{
  devShells.rust = pkgs.mkShell {
    packages = with pkgs; [
      cargo
      rustup
      rust-analyzer
      libiconv
      gcc
      cargo
      rustc
      rustfmt
      rustPackages.clippy
      rust-analyzer
    ];
  };
}
