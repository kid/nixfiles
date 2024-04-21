{ pkgs, ... }:
{
  services.xserver.windowManager.qtile = {
    enable = true;
    backend = "wayland";
  };

  environment.systemPackages = with pkgs; [ mypy ];
}
