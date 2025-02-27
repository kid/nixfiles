{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkModule;
in
mkModule ./. false config { } (_cfg: {
  boot = {
    supportedFilesystems.btrfs = true;
    initrd.supportedFilesystems.btrfs = true;
  };
})
