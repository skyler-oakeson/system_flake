{inputs, ...}: {
  flake = {
    nixosConfigurations = {
      elm = inputs.nixpkgs.lib.nixosSystem {
        modules =
          [
            ./elm/configuration.nix
            inputs.nix-ld.nixosModules.nix-ld
          ]
          ++ inputs.xmonad-contrib.nixosModules;
        specialArgs = {inherit inputs;};
      };
    };
  };
}
