{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    # (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    # inputs.nixos-hardware.nixosModules.common-cpu-amd
    # inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    # inputs.nixos-hardware.nixosModules.common-gpu-amd
    ./disko-config.nix
  ];

  system.stateVersion = "22.11";

  facter.reportPath = ./facter.json;

  nixfiles = {
    device.profiles = [
      "desktop"
      "graphical"
    ];

    system.boot.secureBoot = false;

    programs = {
      gaming.enable = true;
    };

    services = {
      printing.enable = true;
    };

    virtualisation = {
      enable = true;
      docker.enable = true;
      incus.enable = true;
    };

    packages = {
      inherit (pkgs) go;
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos.cachyOverride { mArch = "ZEN4"; };

    extraModulePackages = with config.boot.kernelPackages; [
      r8125
    ];

    kernelParams = [
      "boot.shell_on_fail"
      "amdgpu.dcdebugmask=0x400"
      "preempt=full"
      "amd_pstate=active"
    ];

    loader.systemd-boot.windows."11".efiDeviceHandle = "HD0b";
  };

  networking = {
    hostId = "9371deb4";
    useNetworkd = true;
    interfaces = {
      adm.useDHCP = true;
      lab.useDHCP = true;
    };
    vlans = {
      adm = {
        id = 99;
        interface = "enp16s0";
      };
      lab = {
        id = 1991;
        interface = "enp16s0";
      };
    };
    firewall.enable = false;
  };

  systemd.network = {
    networks = {
      "40-adm" = {
        name = "adm";
        dhcpV4Config = {
          RouteMetric = 2048;
        };
      };
      "40-lab" = {
        name = "lab";
        dhcpV4Config = {
          RouteMetric = 2048;
        };
      };
    };
  };

  services = {
    # NOTE: prevent keyboard from continously going to sleep...
    udev.extraRules = lib.mkAfter ''
      ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTR{idVendor}=="cb10", ATTR{idProduct}=="1257", ATTR{power/control}="on"
    '';

    resolved = {
      enable = true;
      settings.Resolve = {
        DNSSEC = false;
        DNSStubListener = false;
      };
    };

    # Custom schedulers for gaming
    # TODO: move to gaming profile
    scx = {
      enable = true;
      scheduler = "scx_lavd";
    };

    hardware.openrgb.enable = true;

    smartd.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
  hardware = {
    amdgpu.overdrive."enable" = true;

    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  programs.corectrl.enable = true;
  programs.gamescope.args = [
    "-W"
    "3840"
    "-H"
    "2160"
    "-r"
    "138"
    "-f"
    "--adaptive-sync"
    "--force-grab-cursor"
    "--hdr-enabled"
    "--mango"
  ];

  fileSystems = {
    "/persist".neededForBoot = true;
    "/home".neededForBoot = true;
  };

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

  preservation = {
    enable = true;
    preserveAt."/persist" = {
      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
          how = "symlink";
          configureParent = true;
        }
        {
          file = "/etc/ssh/ssh_host_rsa_key";
          how = "symlink";
          configureParent = true;
        }
        {
          file = "/etc/ssh/ssh_host_rsa_key.pub";
          how = "symlink";
          configureParent = true;
        }
        {
          file = "/etc/ssh/ssh_host_ed25519_key";
          how = "symlink";
          configureParent = true;
        }
        {
          file = "/etc/ssh/ssh_host_ed25519_key.pub";
          how = "symlink";
          configureParent = true;
        }
      ];

      directories = [
        "/etc/secureboot"
        "/var/lib/bluetooth"
        "/var/lib/fprint"
        "/var/lib/fwupd"
        "/var/lib/libvirt"
        "/var/lib/power-profiles-daemon"
        "/var/lib/sbctl"
        "/var/lib/systemd/coredump"
        "/var/lib/systemd/rfkill"
        "/var/lib/systemd/timers"
        "/var/log"
        {
          directory = "/var/lib/nixos";
          inInitrd = true;
        }
      ];
    };
  };

  # systemd-machine-id-commit.service would fail, but it is not relevant
  # in this specific setup for a persistent machine-id so we disable it
  #
  # see the firstboot example below for an alternative approach
  systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];

  # let the service commit the transient ID to the persistent volume
  systemd.services.systemd-machine-id-commit = {
    unitConfig.ConditionPathIsMountPoint = [
      ""
      "/persistent/etc/machine-id"
    ];
    serviceConfig.ExecStart = [
      ""
      "systemd-machine-id-setup --commit --root /persistent"
    ];
  };

  # reset / at each boot
  boot.initrd.systemd.services.rollback = {
    wantedBy = [ "initrd.target" ];
    after = [ "initrd-root-device.target" ];
    before = [ "sysroot.mount" ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /mnt

      # Mount the btrfs root to /mnt
      mount -o subvol="@" /dev/disk/by-id/nvme-WD_BLACK_SN8100_2000GB_25264U800487-part2 /mnt

      # Delete root subvolume
      btrfs subvolume delete /mnt/root

      # Create a new empty subvolume
      btrfs subvolume create /mnt/root

      # Unmount /mnt and continue boot process
      umount /mnt
    '';
  };

  zramSwap = {
    enable = true;
  };
}
