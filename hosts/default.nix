{ inputs, ... }:
{
  flake = {
    nixosConfigurations = {
      elm = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          ./elm/configuration.nix
          inputs.nix-ld.nixosModules.nix-ld
        ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
