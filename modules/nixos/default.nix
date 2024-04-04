{ self, config, pkgs, ... }:
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
        extraGroups = [ "audio" "video" "wheel" "libvirtd" "incus-admin" "docker" ];
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

  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.systemd-boot.consoleMode = "auto";

  environment.systemPackages = with pkgs; [
    lm_sensors
    dnsutils
  ];

  stylix = {
    image = ../home-manager/wallpapers/gruvbox-dark-rainbow.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
  };

  system.activationScripts.diff = {
    supportsDryActivation = true;
    text = ''
      if [[ -e /run/current-system ]]; then
        echo "--- diff to current-system"
        ${pkgs.nvd}/bin/nvd --nix-bin-dir=${config.nix.package}/bin diff /run/current-system "$systemConfig"
        echo "---"
      fi
    '';
  };

  # always keep a reference to the source flake that generated each generations
  # environment.etc."current-nixos".source = ./.;

  # system.nixos.label = concatStringsSep "-" ((sort (x: y: x < y) cfg.tags) ++ [ "${cfg.version}.${self.sourceInfo.shortRev or "dirty"}" ]);
  system.nixos.label = (builtins.concatStringsSep "-" (builtins.sort (x: y: x < y) config.system.nixos.tags)) + "${config.system.nixos.version}.${self.sourceInfo.shortRev or "dirty"}";
}
