{ lib, pkgs, ... }:
let
  inherit (lib.modules) mkAfter mkForce mkImageMediaOverride;
in
{
  boot.kernelPackages = mkForce pkgs.linuxPackages;

  boot = {
    kernelParams = mkAfter [
      "noquiet"
      "toram"
    ];

    initrd.systemd = {
      enable = mkImageMediaOverride false;
      emergencyAccess = mkImageMediaOverride false;
    };
  };
}
