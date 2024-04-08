{ config, pkgs, ... }: {
  imports = [ ./primary.nix ];

  user = {
    home = "${
        if pkgs.stdenvNoCC.isDarwin then "/Users" else "/home"
      }/${config.user.name}";
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
      libqalculate
      dig
      # coreutils-full
    ];
  };

  programs.zsh = {
    enable = true;

    # Don't run compinit as home-manager will already take care of it, otherwise this cause a slow start
    enableCompletion = false;
  };

  fonts = {
    packages = with pkgs; [
      material-symbols

      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      roboto

      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
    ];

    enableDefaultPackages = false;

    fontconfig = {
      subpixel.rgba = "none";
      subpixel.lcdfilter = "none";

      hinting.enable = true;
      # hinting.autohint = true;
      hinting.style = "full";
    };

    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Noto Color Emoji" ];
      sansSerif = [ "Noto Sans" "Noto Color Emoji" ];
      monospace = [ "JetBrainsMono Nerd Font" "Noto Color Emoji" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
