let
  mountOptions = [
    "compress=zstd"
    "noatime"
  ];
in
{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/disk/by-id/nvme-WD_BLACK_SN8100_2000GB_25264U800487";
        type = "disk";
        imageSize = "10G";
        content = {
          type = "gpt";
          partitions = {
            nixos = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [
                  "-L"
                  "nixos"
                  "-f"
                ];
                subvolumes = {
                  "@" = { };
                  "@root" = {
                    inherit mountOptions;
                    mountpoint = "/";
                  };
                  "@home" = {
                    inherit mountOptions;
                    mountpoint = "/home";
                  };
                  "@nix" = {
                    inherit mountOptions;
                    mountpoint = "/nix";
                  };
                  "@persist" = {
                    inherit mountOptions;
                    mountpoint = "/persist";
                  };
                };
              };
            };
            # ESP = {
            #   priority = 1;
            #   name = "ESP";
            #   label = "boot";
            #   start = "1M";
            #   end = "512M";
            #   type = "EF00";
            #   content = {
            #     type = "filesystem";
            #     format = "vfat";
            #     mountpoint = "/boot";
            #     mountOptions = [ "umask=0077" ];
            #   };
            # };
          };
        };
      };
    };
  };

  fileSystems = {
    "/persist".neededForBoot = true;
    "/home".neededForBoot = true;
  };
}
