{
  lib,
  localLib,
  self,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.modules) mkDefault;
  inherit (localLib.hardware) ldTernary;

  cfg = config.nixfiles.system;
in
{
  options.nixfiles.system.stateVersion = mkOption {
    type = lib.types.str;
    default = "25.05";
  };

  config.system = {
    # this is the NixOS version that the configuration was generated with
    # this should be change to the version of the NixOS release that the configuration was generated with
    # https://nixos.org/manual/nixos/unstable/release-notes.html
    stateVersion = mkDefault (ldTernary pkgs cfg.stateVersion 6);

    # get the git rev that we are working on and set that to the configurationRevision
    configurationRevision = self.shortRev or self.dirtyShortRev or "dirty";
  };
}
