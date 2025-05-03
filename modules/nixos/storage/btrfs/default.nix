{
  config,
  lib,
  ...
}:
let
  inherit (lib.attrsets) genAttrs;
  inherit (lib.modules) mkIf mkMerge;

  cfg = config.nixfiles.storage;
  impermanenceCfg = config.nixfiles.storage.impermanence;

  mountOptions = [
    "compress=zstd"
    "noatime"
  ];

  script = builtins.readFile ./rollback.sh;
in
{
  config = mkIf (cfg.type == "btrfs") (mkMerge [
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
                subvolumes =
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
                  }
                  // genAttrs cfg.extraSubVolumes (mountpoint: {
                    inherit mountpoint mountOptions;
                  });
              };
            };
          };
        };
      };

      virtualisation.vmVariantWithDisko = {
        disko.devices.disk.main.imageSize = "10G";
        virtualisation.fileSystems."/home".neededForBoot = true;
      };
    }

    (mkIf impermanenceCfg.enable {
      boot.initrd.systemd.services.rollback = {
        wantedBy = [ "initrd.target" ];
        after = [ "initrd-root-device.target" ];
        before = [ "sysroot.mount" ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        inherit script;
      };
    })
  ]);
}
