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

  programs.zsh = {
    enable = true;

    # Don't run compinit as home-manager will already take care of it, otherwise this cause a slow start
    enableGlobalCompInit = false;
  };


  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];
}
