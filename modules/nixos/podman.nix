{ pkgs, ... }:
{
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = false;
      extraPackages = [ pkgs.zfs ];
    };

    # containers.storage.settings = {
    #   driver = "zfs";
    # };

    oci-containers = {
      backend = "podman";
    };
  };
}
