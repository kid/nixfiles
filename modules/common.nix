{ inputs, config, pkgs, ... }:
{
  imports = [ ./primary.nix ./nix.nix ];

  user = {
    home = "${if pkgs.stdenvNoCC.isDarwin then "/Users" else "/home"}/${config.user.name}";
    shell = pkgs.zsh;
  };

  hm = import ./home-manager;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  environment = {
    systemPackages = with pkgs; [
      watch
      # coreutils-full
    ];
  };

  # environment = {
  #   shells = with pkgs; [ zsh ];
  # };

  # We should not need this, but if we remove it, Darwin PATH is wrong
  programs.zsh.enable = pkgs.stdenvNoCC.isDarwin;

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];
}
