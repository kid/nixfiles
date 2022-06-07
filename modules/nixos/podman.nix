{ pkgs, ... }:
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    extraPackages = [ pkgs.zfs ];
  };
}
