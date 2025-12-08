{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hardware.drivers;

  amd = {
    boot.kernelParams = [
      "video=DP-1:3840x2160@60"
      "video=DP-2:2560x1440@144"
    ];

    boot.initrd.kernelModules = ["amdgpu"];
    environment.systemPackages = with pkgs; [lact];

    # Enable for wayland and xorg
    services.xserver = {
      videoDrivers = ["amdgpu"];
      enableTearFree = true;
    };

    # For 32 bit applications
    hardware.graphics.enable32Bit = true;

    # Start the gpu management deamon
    systemd = {
      packages = with pkgs; [lact];
      services.lactd.wantedBy = ["multi-user.target"];
    };
  };

  nvidia = {
    hardware.graphics = {
      enable = true;
    };

    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;

      # Helps with suspend and wake
      powerManagement.enable = true;

      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
in {
  options = {
    hardware.drivers = lib.mkOption {
      type = lib.types.enum [
        "AMD"
        "NVIDIA"
      ];
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg == "AMD") amd)
    (lib.mkIf (cfg == "NVIDIA") nvidia)
  ];
}
