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

  mt7925Patches = [
    {
      name = "mt7925-01-fix-deadlock-in-roc-abort";
      patch = "${mt7925PatchDir}/0001-wifi-mt76-mt7925-fix-potential-deadlock-in-mt7925_ro.patch";
    }
    {
      name = "mt7925-02-fix-list-corruption-in-wcid-cleanup";
      patch = "${mt7925PatchDir}/0002-wifi-mt76-fix-list-corruption-in-mt76_wcid_cleanup.patch";
    }
    {
      name = "mt7925-03-fix-null-pointer-and-firmware-reload";
      patch = "${mt7925PatchDir}/0003-wifi-mt76-mt792x-fix-NULL-pointer-and-firmware-reloa.patch";
    }
    {
      name = "mt7925-04-mt7921-add-mutex-protection";
      patch = "${mt7925PatchDir}/0004-wifi-mt76-mt7921-add-mutex-protection-in-critical-pa.patch";
    }
    {
      name = "mt7925-05-mt7921-fix-deadlock-in-sta-removal";
      patch = "${mt7925PatchDir}/0005-wifi-mt76-mt7921-fix-deadlock-in-sta-removal-and-sus.patch";
    }
    {
      name = "mt7925-06-add-null-pointer-protection-for-mlo";
      patch = "${mt7925PatchDir}/0006-wifi-mt76-mt7925-add-comprehensive-NULL-pointer-prot.patch";
    }
    {
      name = "mt7925-07-add-mutex-protection";
      patch = "${mt7925PatchDir}/0007-wifi-mt76-mt7925-add-mutex-protection-in-critical-pa.patch";
    }
    {
      name = "mt7925-08-add-mcu-command-error-handling";
      patch = "${mt7925PatchDir}/0008-wifi-mt76-mt7925-add-MCU-command-error-handling.patch";
    }
    {
      name = "mt7925-09-add-lockdep-assertions";
      patch = "${mt7925PatchDir}/0009-wifi-mt76-mt7925-add-lockdep-assertions-for-mutex-ve.patch";
    }
    {
      name = "mt7925-10-fix-mlo-roaming-and-roc-setup";
      patch = "${mt7925PatchDir}/0010-wifi-mt76-mt7925-fix-MLO-roaming-and-ROC-setup-issue.patch";
    }
    {
      name = "mt7925-11-fix-ba-session-teardown";
      patch = "${mt7925PatchDir}/0011-wifi-mt76-mt7925-fix-BA-session-teardown-during-beac.patch";
    }
    {
      name = "mt7925-12-fix-roc-deadlocks-and-race-conditions";
      patch = "${mt7925PatchDir}/0012-wifi-mt76-mt7925-fix-ROC-deadlocks-and-race-conditio.patch";
    }
    {
      name = "mt7925-13-fix-double-wcid-initialization-race";
      patch = "${mt7925PatchDir}/0013-wifi-mt76-mt7925-fix-double-wcid-initialization-race.patch";
    }
  ];
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
  };
}
