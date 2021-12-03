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

    binaryCaches = [
      "https://nix-community.cachix.org"
    ];
    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
    linkInputs = true;
  };

  security.sudo.wheelNeedsPassword = false;

  # For autocompletion of system packages
  environment.pathsToLink = [ "/share/zsh" ];

  services.openssh.enable = true;
  services.openssh.useDns = true;
}
