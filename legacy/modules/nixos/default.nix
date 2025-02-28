{
  # self,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../common.nix
    # ../stylix.nix
    ./wine.nix
    ./xremap.nix
  ];

  system.stateVersion = "22.11";

  users = {
    defaultUserShell = pkgs.zsh;
    mutableUsers = false;
    users = {
      "${config.user.name}" = {
        isNormalUser = true;
        createHome = true;
        useDefaultShell = true;
        extraGroups = [
          "audio"
          "video"
          "wheel"
          "libvirtd"
          "incus-admin"
          "docker"
        ];
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

  # boot.loader.systemd-boot.consoleMode = "auto";

  environment.systemPackages = with pkgs; [
    lm_sensors
  ];

  programs.nh = {
    enable = true;
    # clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 5";
    flake = "/home/${config.user.name}/Code/nixfiles";
  };

  # always keep a reference to the source flake that generated each generations
  # environment.etc."current-nixos".source = ./.;

  # system.nixos.label =
  #   (builtins.concatStringsSep "-" (builtins.sort (x: y: x < y) config.system.nixos.tags))
  #   + "${config.system.nixos.version}.${self.sourceInfo.shortRev or "dirty"}";

  nixpkgs.config.permittedInsecurePackages = [
    # "electron-30.5.1"
    "wire-desktop-3.36.3462"
  ];
}
