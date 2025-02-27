{ config, namespace, ... }:
{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/vda";
        type = "disk";
        imageSize = "10G";
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
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                # mountpoint = "/partition-root";
                extraArgs = [
                  "-L"
                  "nixos"
                  "-f"
                ];
                subvolumes = {
                  "/rootfs" = {
                    mountpoint = "/";
                    mountOptions = [
                      # "subvol=rootfs"
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      # "subvol=home"
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  # "/home/${config.${namespace}.user.name}" = { };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      # "subvol=nix"
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/persist" = {
                    mountpoint = "/persist";
                    mountOptions = [
                      # "subvol=persist"
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/swap" = {
                    mountpoint = "/swap";
                    swap.swapfile.size = "2G";
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  fileSystems = {
    "/persist".neededForBoot = true;
    "/home".neededForBoot = true;
  };

  # the filesystems for the VM are derived directly from the disko config
  # since disko doesn't have a neededForBoot passthru, neededForBoot is false
  # so we have to define it requirement separately for the vm otherwise it won't be mounted in stage 1
  virtualisation.vmVariantWithDisko = {
    virtualisation.fileSystems."/home".neededForBoot = true;
  };
}
