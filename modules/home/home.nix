{ lib, osConfig, ... }:
let
  inherit (lib.modules) mkDefault;
in
{
  home.stateVersion = osConfig.nixfiles.system.stateVersion;

  # reload system units when chaning configs
  systemd.user.startServices = mkDefault "sd-switch";

  # let home-manager manage itslef in standalone mode
  programs.home-manager.enable = true;
}
