{ inputs, config, pkgs, ... }:
{
  imports = [ ./primary.nix ];

  user = {
    home = "${if pkgs.stdenvNoCC.isDarwin then "/Users" else "/home"}/${config.user.name}";
    shell = pkgs.zsh;
  };

  hm = import ./home-manager;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # environment = {
  #   shells = with pkgs; [ zsh ];
  # };

  programs.zsh.enable = true;

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];
}
