{ config, pkgs, ... }:
{
  imports = [ ../common.nix ../nix.nix ];

  system.stateVersion = "22.11";

  users = {
    defaultUserShell = pkgs.zsh;
    mutableUsers = false;
    users = {
      "${config.user.name}" = {
        isNormalUser = true;
        createHome = true;
        useDefaultShell = true;
        extraGroups = [ "audio" "video" "wheel" "libvirtd" ];
        initialPassword = "foo";
      };
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Brussels";

  security.sudo.wheelNeedsPassword = false;

  # For autocompletion of system packages
  environment.pathsToLink = [ "/share/zsh" ];

  services.openssh.enable = true;

  boot.loader.systemd-boot.configurationLimit = 5;


  environment.systemPackages = with pkgs; [
    lm_sensors
    dnsutils
  ];
}
