{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  options = {
    desktopEnvironment = {
      xmonad.enable = lib.mkEnableOption "enable xmonad and its dependencies";
    };
  };

  config = lib.mkIf config.desktopEnvironment.xmonad.enable {
    environment.systemPackages = with pkgs; [
      inputs.self.packages.${pkgs.system}.kitty
      dmenu
      lf
      pavucontrol
      scrot
      xdotool
      xmobar
      xwallpaper
    ];

    services.picom.enable = true;

    services.displayManager.ly = {
      enable = true;
    };

    services.xserver = {
      displayManager.sessionCommands = ''
        xwallpaper --zoom ~/.config/wallpapers/lighthouse.jpg
        xrandr --output DisplayPort-2 --mode 2560x1440 --rate 144
      '';
      enable = true;
      xkb.layout = "us";
      autoRepeatDelay = 400;
      autoRepeatInterval = 35;
      windowManager.xmonad = {
        enable = true;
        enableConfiguredRecompile = true;
        enableContribAndExtras = true;
        flake = {
          enable = true;
        };
      };
    };

    fonts = {
      packages = with pkgs; [
        nerd-fonts._3270
        nerd-fonts.jetbrains-mono
        lato
        spleen
        newcomputermodern
      ];

      fontconfig = {
        defaultFonts = {
          serif = [ "Computer Modern" ];
          sansSerif = [ "Lato" ];
          monospace = [ "JetBrainsMono NF SemiBold" ];
        };
      };
    };
  };
}
