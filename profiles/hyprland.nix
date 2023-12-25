{ inputs, pkgs, ... }:
{
  imports = [
    ../modules/nixos/leftwm.nix
    ../modules/nixos/wayland
    ../modules/nixos/wine.nix
  ];

  hm.imports = [
    # inputs.hyprland.homeManagerModules.default
    ../modules/home-manager/desktop.nix
    ../modules/home-manager/leftwm.nix
    ../modules/home-manager/wayland
    # ../modules/home-manager/wayland/hyprland
    ./home-manager/desktop.nix
    {
      wayland.windowManager.hyprland.plugins = [ inputs.hy3.packages.${pkgs.system}.hy3 ];
    }
  ];

  user.name = "kid";

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };

  # services.xserver = {
  #   enable = true;
  #   displayManager.gdm = {
  #     enable = true;
  #     wayland = true;
  #   };
  # };

  # xdg.portal.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-gtk ];

  # Use wayland where possible (electron)
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    hyprland
    wayland
    wdisplays
  ];
}
