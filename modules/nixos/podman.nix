{
  pkgs,
  config,
  ...
}:
{
  virtualisation = {
    podman = {
      enable = false;
      autoPrune.enable = true;
      dockerCompat = !config.virtualisation.docker.enable;
      extraPackages = [ pkgs.zfs ];
    };

    containers.enable = false;
    # containers.storage.settings = {
    #   driver = "zfs";
    # };
  };
}
