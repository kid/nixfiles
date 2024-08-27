{
  pkgs,
  config,
  ...
}:
{
  virtualisation = {
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = !config.virtualisation.docker.enable;
      extraPackages = [ pkgs.zfs ];
    };

    containers.enable = true;
    # containers.storage.settings = {
    #   driver = "zfs";
    # };
  };
}
