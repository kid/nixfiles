{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  # MT7925 WiFi driver patches - fixes kernel panics, mutex deadlocks, and system hangs
  # https://github.com/zbowling/mt7925
  mt7925PatchDir = "${inputs.mt7925}/kernels/6.18";

  mt7925Patches =
    let
      patchFiles = lib.sort (a: b: a < b) (lib.attrNames (builtins.readDir mt7925PatchDir));
      mt7925PatchFiles = lib.filter (file: lib.hasSuffix ".patch" file) patchFiles;
    in
    map (file: {
      name = lib.removeSuffix ".patch" file;
      patch = "${mt7925PatchDir}/${file}";
    }) mt7925PatchFiles;
in
{
  imports = with inputs.nixos-hardware.nixosModules; [
    framework-amd-ai-300-series
  ];

  boot.kernelPatches = mt7925Patches;

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
