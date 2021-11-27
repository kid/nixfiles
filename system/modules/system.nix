{ config, pkgs, ... }:
{
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Brussels";

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    allowedUsers = [ "root" "@wheel" ];
    trustedUsers = [ "root" "@wheel" ];

    autoOptimiseStore = true;
    gc.automatic = true;
  };

  security.sudo.wheelNeedsPassword = false;

  # For autocompletion of system packages
  environment.pathsToLink = [ "/share/zsh" ];
}
