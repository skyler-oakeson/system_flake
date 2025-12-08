{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    kitty
    dmenu
    xmobar
    xwallpaper
  ];

  services.picom.enable = true;

  services.displayManager.ly = {
    enable = true;
  };

  services.xserver = {
    displayManager.sessionCommands = ''
      xwallpaper --zoom ~/.config/wallpapers/trees_river_painting.jpg
    '';
    enable = true;
    xkb.layout = "us";
    windowManager.xmonad = {
      enable = true;
      enableConfiguredRecompile = true;
      enableContribAndExtras = true;
      flake = {
        enable = true;
      };
    };
  };
}
