{ inputs, ... }:
let
  wrappers = inputs.wrappers;
in
{
  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    {
      packages.nvim = import ./nvim {
        inherit
          inputs
          lib
          pkgs
          wrappers
          ;
      };
    };
}
