{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    framework-amd-ai-300-series
  ];

  nixfiles = {
    device.profiles = [
      "laptop"
      "graphical"
    ];

    system.boot.secureBoot = true;

    storage = {
      type = "btrfs";
      enableDisko = true;
      mainDevice = "/dev/disk/by-id/nvme-SHPP41-2000GM_ASD9N54741120A36G_1";
      impermanence = {
        enable = true;
        persistence."/persist/system".directories = [
          "/etc/NetworkManager/system-connections"
          "/var/lib/iwd"
          "/var/lib/fprint"
        ];
      };
    };

    services = {
      printing.enable = true;
    };

    programs = {
      gaming.enable = true;
    };

    packages = {
      inherit (pkgs) fw-ectool;
    };
  };

  networking = {
    useNetworkd = lib.mkForce false;
    networkmanager.enable = lib.mkForce true;
    networkmanager.wifi.backend = "iwd";
    wireless.iwd.enable = true;
  };

  powerManagement.powertop.enable = true;

  hardware = {
    # FIXME: requirement for xremap, move it there
    uinput.enable = true;

    sensor.iio.enable = true;

    bluetooth.enable = true;

    enableRedistributableFirmware = true;
  };
}
