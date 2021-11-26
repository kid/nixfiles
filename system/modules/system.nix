{ pkgs, ... }:
{
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Brussels";

  nix = {
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "root" "@wheel" ];

    autoOptimiseStore = true;
    gc.automatic = true;
  };

  environment.systemPackages = with pkgs; [
    git
  ];
}
