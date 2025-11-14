{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.nvim = import ./nvim.nix { inherit inputs pkgs; };
    };
}
