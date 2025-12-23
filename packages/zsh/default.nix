{
  wrappers,
  pkgs,
  ...
}:
wrappers.lib.wrapPackage {
  inherit pkgs;
  package = pkgs.zsh;
  flags = {
    "-d" = { };
    "-f" = { };
    "-c" = "source ${./zshrc}";
  };
}
