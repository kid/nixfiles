{
  lib,
  # pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;

  cfg = config.nixfiles.programs.gaming;
in
{
  config = mkIf cfg.enable {
    # environment.systemPackages = with pkgs; [
    #   lutris
    #   umu-launcher
    # ];
  };
}
