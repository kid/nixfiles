{
  lib,
  pkgs,
  ...
}:
{
  facter.reportPath = ./facter.json;

  nixfiles = {
    device.profiles = [
      "laptop"
      "graphical"
    ];

    storage = {
      type = "btrfs";
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

    graphics.extraPackages = with pkgs; [
      amdvlk
    ];

    sensor.iio.enable = true;
  };

  services = {
    libinput = {
      touchpad = {
        naturalScrolling = true;
        tapping = false;
        clickMethod = "clickfinger";
      };
    };
  };
}
