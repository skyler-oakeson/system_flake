{
  wrappers,
  pkgs,
  ...
}:
{
  packages.kitty = wrappers.lib.wrapPackage {
    inherit pkgs;
    package = pkgs.kitty;
    flags = {
      "--config" = builtins.toString ./kitty.conf;
    };
  };
}
