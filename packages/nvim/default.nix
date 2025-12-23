{
  wrappers,
  pkgs,
  lib,
  ...
}:
let

  # PLUGIN NOT IN NIXPKGS
  # <PLUGIN NAME> = pkgs.vimUtils.buildVimPlugin {
  #   name = "<PLUGIN NAME>";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "<OWNER>";
  #     repo = "<REPO NAME>";
  #     rev = "<BRANCH | COMMIT | TAG>";
  #     hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # nix will provide all
  #   };
  # };

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
    miasma-nvim
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
{
  packages.nvim = wrappers.lib.wrapPackage {
    inherit pkgs;
    package = pkgs.neovim-unwrapped;
    env = {
      NVIM_APPNAME = name;
    };
    flags = {
      "-u" = builtins.toString ./nvim-config/init.lua;
      "--cmd" = "set runtimepath^=${./nvim-config} | set packpath^=${packpath}";
    };
    runtimeInputs = with pkgs; [
      git
      fzf
      ripgrep
      nixfmt
      nixd
    ];
  };
}
