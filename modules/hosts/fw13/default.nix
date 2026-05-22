{
  inputs,
  lib,
  den,
  nf,
  ...
}:
{
  den.hosts.x86_64-linux.fw13 = {
    users.kid = { };
  };

  den.aspects.fw13 = {
    includes = [
      den._.hostname
      nf.base
      nf.desktop.plasma
      nf.stylix
    ];

    nixos =
      { config, pkgs, ... }:
      {
        imports = [
          inputs.niri.nixosModules.niri
          inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
        ];

        nixpkgs = {
          overlays = [
            inputs.niri.overlays.niri
          ];
        };

        users.users.kid = {
          extraGroups = lib.mkAfter [
            "networkmanager"
            "uinput"
            "realtime"
          ];
        };

        environment = {
          systemPackages = lib.mkAfter (
            with pkgs;
            [
              fw-ectool
              config.boot.kernelPackages.cpupower
              sbctl
            ]
          );

          persistence."/persist/system" = {
            hideMounts = true;
            files = [
              "/etc/machine-id"
              "/etc/ssh/ssh_host_rsa_key"
              "/etc/ssh/ssh_host_rsa_key.pub"
              "/etc/ssh/ssh_host_ed25519_key"
              "/etc/ssh/ssh_host_ed25519_key.pub"
            ];
            directories = [
              "/var/lib/bluetooth"
              "/var/lib/fwupd"
              "/var/lib/nixos"
              "/var/lib/sddm"
              "/var/log"
              "/etc/NetworkManager/system-connections"
              "/var/lib/iwd"
              "/var/lib/fprint"
              "/var/lib/sbctl"
            ];
          };
        };

        fileSystems = {
          "/persist/system".neededForBoot = lib.mkForce true;
        };

        disko.devices.disk.main = {
          device = "/dev/disk/by-id/nvme-SHPP41-2000GM_ASD9N54741120A36G_1";
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
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/persist/system" = {
                      mountpoint = "/persist/system";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                  };
                };
              };
            };
          };
        };

        virtualisation.vmVariantWithDisko = {
          disko.devices.disk.main.imageSize = "10G";
          virtualisation.fileSystems."/home".neededForBoot = true;
          virtualisation.fileSystems."/persist/system".neededForBoot = true;
        };

        networking = {
          useNetworkd = lib.mkForce false;
          networkmanager.enable = lib.mkForce true;
          networkmanager.wifi.backend = "iwd";
          wireless.iwd.enable = true;
        };

        nix = {
          registry =
            (lib.mapAttrs (_: flake: { inherit flake; }) (
              lib.filterAttrs (name: value: lib.types.isType "flake" value && name != "self") inputs
            ))
            // {
              nixpkgs = lib.mkForce { flake = inputs.nixpkgs; };
            };

          settings = {
            extra-platforms = config.boot.binfmt.emulatedSystems;
          };
        };

        security = {
          pam.loginLimits = [
            {
              domain = "@realtime";
              type = "-";
              item = "rtprio";
              value = 98;
            }
            {
              domain = "@realtime";
              type = "-";
              item = "memlock";
              value = "unlimited";
            }
            {
              domain = "@realtime";
              type = "-";
              item = "nice";
              value = -11;
            }
          ];
        };

        services = {
          displayManager.autoLogin = {
            enable = false;
            user = "kid";
          };

          udev.extraRules = ''
            ACTION=="add|change", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"
            ACTION=="add|change", SUBSYSTEM=="usb", TEST=="power/wakeup", ATTR{power/wakeup}="disabled"
            SUBSYSTEM=="ata_port", KERNEL=="ata*", ATTR{device/power/control}="auto"
            KERNEL=="cpu_dma_latency", GROUP="realtime"
          '';

        };

        boot = {
          lanzaboote = {
            enable = true;
            pkiBundle = "/var/lib/sbctl";
          };

          loader.systemd-boot.enable = lib.mkForce false;
        };

        hardware = {
          uinput.enable = true;
          sensor.iio.enable = true;
        };

        powerManagement.powertop.enable = true;
      };
  };
}
