{ inputs, pkgs, ... }:
{
  imports = [
    ../modules/nixos/wayland
    ../modules/nixos/wine.nix
  ];

  hm.imports = [
    inputs.hyprland.homeManagerModules.default
    ../modules/home-manager/desktop.nix
    ../modules/home-manager/wayland
    # ../modules/home-manager/wayland/hyprland
    ./home-manager/desktop.nix
  ];
  user.name = "kid";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    enableNvidiaPatches = true;
  };

  # services.xserver = {
  #   enable = true;
  #   displayManager.gdm = {
  #     enable = true;
  #     wayland = true;
  #   };
  # };

  xdg.portal.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-gtk ];

  # Use wayland where possible (electron)
  environment.variables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    hyprland
    wayland
    wdisplays
  ];
}
