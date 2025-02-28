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
  environment = {
    defaultPackages = lib.mkForce [ ];

    systemPackages = with pkgs; [
      curl
      dnsutils
      usbutils
      lshw
      pciutils
      rsync
      util-linux
    ];
  };

  ${namespace} = {
    nix = mkDefault enabled;
    theme.stylix = mkDefault enabled;
    hardware.power = mkDefault enabled;
  };
})
