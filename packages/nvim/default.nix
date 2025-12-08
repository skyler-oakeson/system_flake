{
  wrappers,
  pkgs,
  lib,
  ...
}:
let
  startPlugins = with pkgs.vimPlugins; [
    oil-nvim
    nvim-lspconfig
    blink-cmp
    nvim-surround
    toggleterm-nvim
    mini-pick
    gitsigns-nvim
    lazydev-nvim
    nvim-autopairs
    nvim-treesitter.withAllGrammars
    nvim-treesitter-context
    melange-nvim
  ];

  foldPlugins = builtins.foldl' (
    acc: next:
    acc
    ++ [
      next
    ]
    ++ (foldPlugins (next.dependencies or [ ]))
  ) [ ];

  startPluginsWithDeps = lib.unique (foldPlugins startPlugins);

  name = "nvim-wrapped";
  packpath = pkgs.runCommandLocal "packpath" { } ''
    mkdir -p $out/pack/${name}/start

    ${lib.concatMapStringsSep "\n" (
      plugin: "ln -vsfT ${plugin} $out/pack/${name}/start/${lib.getName plugin}"
    ) startPluginsWithDeps}
  '';
in
wrappers.lib.wrapPackage rec {
  inherit pkgs;
  package = pkgs.neovim;
  env = {
    NVIM_APPNAME = name;
  };
  flags = {
    "-u" = builtins.toString ./nvim-config/init.lua;
    "--cmd" = "set runtimepath^=${./nvim-config} | set packpath^=${packpath}";
  };
  runtimeInputs = with pkgs; [
    nixfmt
    basedpyright
    bash-language-server
    clang-tools
    csharp-ls
    jdt-language-server
    git
    lua-language-server
    marksman
    nixd
    rustup
    texlab
    typescript-language-server
    vscode-langservers-extracted
    (haskellPackages.ghcWithPackages (
      self: with self; [
        haskell-language-server
      ]
    ))
  ];
}
