{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kitty
    dmenu
    xmobar
  ];

  services.xserver.xkb.layout = "us";
  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.xmonad = {
    enable = true;
    extraPackages = haskellPackages: [
      haskellPackages.dbus
      haskellPackages.List
      haskellPackages.monad-logger
    ];
  };
}
