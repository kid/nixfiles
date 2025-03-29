{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkForce;
in
{

  environment = {
    defaultPackages = mkForce [ ];
  };

  nixfiles.packages = {
    inherit (pkgs)
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
      ;
  };
}
