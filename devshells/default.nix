{ inputs, ... }:
{
  perSystem =
    { ... }:
    {
      imports = [
        ./nix.nix
        # ./python.nix
        ./rust.nix
        ./xmonad.nix
      ];
    };
}
