{
  imports = [
    ./disko-config.nix
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      # extraInstallCommands = ''
      #   ${pkgs.gnused}/bin/sed -E -i 's/default nixos-generation-[0-9]+\.conf/default @saved/g' /boot/loader/loader.conf
      # '';
    };
  };

  system.stateVersion = "25.05";

  disko.devices.disk.main.imageSize = "10G";
}
