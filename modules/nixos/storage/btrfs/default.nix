{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.nixfiles.storage.btrfs;
in
{
  options.nixfiles.storage.btrfs.enable = mkEnableOption "btrfs";

  config = mkIf cfg.enable {
    boot = {
      supportedFilesystems.btrfs = true;
      initrd.supportedFilesystems.btrfs = true;
    };
  };
}
