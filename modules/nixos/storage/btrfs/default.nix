{
  config,
  lib,
  ...
}:
with lib;
let
  inherit (lib) types;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.nixfiles.storage.btrfs;
  impermanenceCfg = config.nixfiles.storage.impermanence;

  mountOptions = [
    "compress=zstd"
    "noatime"
  ];

  script = builtins.readFile ./rollback.sh;
in
{
  options.nixfiles.storage.btrfs = {
    enable = mkEnableOption "btrfs";
    mainDevice = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      boot = {
        supportedFilesystems.btrfs = true;
        initrd.supportedFilesystems.btrfs = true;
      };

      services = {
        btrfs = {
          autoScrub = {
            enable = true;
            fileSystems = [ "/" ];
            interval = "weekly";
          };
        };
      };

      disko.devices.disk.main = {
        device = cfg.mainDevice;
        type = "disk";

        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              label = "boot";
              start = "1M";
              end = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            nixos = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [
                  "-L"
                  "nixos"
                  "-f"
                ];
                subvolumes = mkMerge [
                  {
                    "/root" = {
                      inherit mountOptions;
                      mountpoint = "/";
                    };
                    "/home" = {
                      inherit mountOptions;
                      mountpoint = "/home";
                    };
                    "/nix" = {
                      inherit mountOptions;
                      mountpoint = "/nix";
                    };
                    "/var/log" = {
                      inherit mountOptions;
                      mountpoint = "/var/log";
                    };
                  }
                  (mkIf impermanenceCfg.enable {
                    "/persist/system" = {
                      inherit mountOptions;
                      mountpoint = "/persist";
                    };
                  })
                ];
              };
            };
          };
        };
      };

      fileSystems."/var/log".neededForBoot = true;

      virtualisation.vmVariantWithDisko = {
        disko.devices.disk.main.imageSize = "10G";
        virtualisation.fileSystems."/home".neededForBoot = true;
      };
    }

    (mkIf impermanenceCfg.enable {
      fileSystems."/persist/system".neededForBoot = true;

      boot.initrd.systemd.services.rollback = {
        wantedBy = [ "initrd.target" ];
        after = [ "initrd-root-device.target" ];
        before = [ "sysroot.mount" ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        inherit script;
      };

      virtualisation.vmVariantWithDisko = {
        virtualisation.fileSystems."/persist".neededForBoot = true;
      };
    })
  ]);
}
