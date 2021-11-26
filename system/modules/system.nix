{ pkgs, ...}:
{
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Brussels";

  nix.autoOptimiseStore = true;

  nix.gc = {
    automatic = true;
  };

  environment.systemPackages = with pkgs; [
    git
  ];
}
