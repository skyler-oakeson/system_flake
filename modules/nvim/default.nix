{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.symlinkJoin {
      name = "nvim";
      buildInputs = [
        pkgs.makeWrapper
      ];
      paths = [ inputs.neovim-nightly-overlay.packages.${pkgs.system}.default ];
      postBuild = ''
        wrapProgram $out/bin/nvim \
            --append-flags "-u ${inputs.nvim-config}/init.lua"
      '';
    })
  ];
}
