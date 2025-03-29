{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.nixfiles.suites.common;
in
{
  options.nixfiles.suites.common.enable = mkEnableOption "common";

  config = mkIf cfg.enable {
    nixfiles = {
      # nix.enable = mkDefault true;
      theme.stylix.enable = mkDefault true;
      hardware = {
        firmware.enable = mkDefault true;
        power.enable = mkDefault true;
      };
      system.env.enable = mkDefault true;
      security.sops.enable = mkDefault true;
    };

    environment = {
      defaultPackages = lib.mkForce [ ];

      systemPackages = with pkgs; [
        curl
        dnsutils
        usbutils
        ethtool
        lshw
        pciutils
        rsync
        util-linux

        btop
        htop
        watch
        libqalculate
      ];
    };

    hardware.enableAllFirmware = true;

    # TODO: move this to its own module, maybe back to home-manager?
    programs.nixvim.enable = true;
    programs.nixvim.defaultEditor = true;
  };
}
