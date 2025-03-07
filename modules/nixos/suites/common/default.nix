{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkDefault;
  inherit (lib.${namespace}) enabled mkModule;
in
mkModule ./. false config { } (_cfg: {
  ${namespace} = {
    nix = mkDefault enabled;
    theme.stylix = mkDefault enabled;
    hardware = {
      firmware = mkDefault enabled;
      power = mkDefault enabled;
    };
    system.env = mkDefault enabled;
    security.sops = mkDefault enabled;
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
})
