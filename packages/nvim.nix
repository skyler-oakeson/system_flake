{ inputs, pkgs, ... }:

pkgs.symlinkJoin {
  name = "nvim";
  buildInputs = [
    pkgs.makeWrapper
  ];
  paths = [ inputs.neovim-nightly-overlay.packages.${pkgs.system}.default ];
  postBuild = with pkgs; ''
    wrapProgram $out/bin/nvim \
        --append-flags '-u ${inputs.nvim-config}/init.lua' \
        --prefix PATH : ${
          lib.makeBinPath [
            nixd
            nixfmt-rfc-style
            csharp-ls
            clang-tools
            marksman
            rustup
            jdt-language-server
            typescript-language-server
            lua-language-server
            texlab
            csharp-ls
            basedpyright
            vscode-langservers-extracted
          ]
        }
  '';
}
