{ pkgs, ... }:
{
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
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
