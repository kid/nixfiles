{
  imports = [
    # ../modules/nixos/wayland
    # ../modules/nixos/wine.nix
    ../modules/nixos/sddm.nix
  ];

  hm.imports = [
    # inputs.hyprland.homeManagerModules.default
    ../modules/home-manager/desktop.nix
    ../modules/home-manager/plasma.nix
    ../modules/home-manager/xremap.nix
    # ../modules/home-manager/leftwm.nix
    # ../modules/home-manager/wayland
    # ../modules/home-manager/wayland/hyprland
    ./home-manager/desktop.nix
  ];

  user.name = "kid";

  # programs.hyprland = {
  #   enable = true;
  #   package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  #   xwayland.enable = true;
  # };
  #
  # services.xserver = {
  #   enable = true;
  #   displayManager.gdm = {
  #     enable = true;
  #     wayland = true;
  #   };
  # };

  # xdg.portal.enable = true;
  # xdg.portal.wlr.enable
  # xdg.portal = {
  #   enable = true;
  #   wlr.enable = true;
  #   extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
  # };
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-gtk ];

  # Use wayland where possible (electron)
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # environment.systemPackages = with pkgs; [ hyprland wayland wdisplays ];
}
