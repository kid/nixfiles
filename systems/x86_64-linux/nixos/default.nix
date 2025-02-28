{
  config,
  inputs,
  modulesPath,
  pkgs,
  ...
}:
let
  kernelPackages = pkgs.linuxPackages_cachyos;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-amd

    # TODO: move to shared modules in flake.nix
    inputs.nur.modules.nixos.default
    inputs.chaotic.nixosModules.default

    ../../../legacy/modules/nixos
    ../../../legacy/modules/nixos/desktop.nix
    ../../../legacy/modules/nixos/games.nix
    ../../../legacy/modules/nixos/docker.nix
    ../../../legacy/modules/nixos/podman.nix
    ../../../legacy/modules/nixos/virtualization.nix
    ../../../legacy/modules/nixos/printing.nix
    ../../../legacy/profiles/plasma6.nix
  ];

  nixfiles.archetypes.gaming.enable = true;

  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnfree = true;
    };
    overlays = [
      # self.overlays.stable-packages
      inputs.nur.overlays.default
    ];
  };

  boot = {
    inherit kernelPackages;

    # consoleLogLevel = 0;
    # initrd.verbose = false;
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];
    resumeDevice = "/dev/disk/by-label/swap";

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        extraInstallCommands = ''
          ${pkgs.gnused}/bin/sed -E -i 's/default nixos-generation-[0-9]+\.conf/default @saved/g' /boot/loader/loader.conf
        '';
      };
    };

    # blacklistedKernelModules = [ "r8169" ];

    extraModulePackages = with config.boot.kernelPackages; [
      r8125
      # r8168
    ];

    kernelParams = [
      "boot.shell_on_fail"
      "quiet"
      "udev.log_level=0"
      "amdgpu.dcdebugmask=0x400"
      "preempt=full"
    ];

    # Steamdeck adjustments
    kernel.sysctl = {
      "kernel.sched_cfs_bandwidth_slice_us" = 3000;
      "net.ipv4.tcp_fin_timeout" = 5;
      "vm.max_map_count" = 2147483642;
    };

    initrd.supportedFilesystems = [ "zfs" ];

    supportedFilesystems = [
      "zfs"
      "ntfs"
    ];

    zfs = {
      package = pkgs.zfs_2_3;
      devNodes = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_1TB_S5GXNG0NB01573T-part5";
    };
  };

  chaotic = {
    hdr = {
      # enable = true;
      specialisation.enable = false;
    };
    # mesa-git.enable = true;
  };
  fileSystems = {
    "/" = {
      device = "rpool/SYSTEM/root";
      fsType = "zfs";
      options = [ "zfsutil" ];
      neededForBoot = true;
    };

    "/var" = {
      device = "rpool/SYSTEM/var";
      fsType = "zfs";
      options = [ "zfsutil" ];
      neededForBoot = true;
    };

    "/nix" = {
      device = "rpool/LOCAL/nix";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/home" = {
      device = "rpool/USER/home";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

    "/boot" = {
      device = "/dev/disk/by-label/EFI";
      fsType = "vfat";
    };

    "/var/lib/docker" = {
      device = "/dev/zvol/rpool/docker";
      fsType = "ext4";
    };
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  networking = {
    hostId = "9371deb4";
    useDHCP = false;
    useNetworkd = true;
    vlans = {
      adm = {
        id = 99;
        interface = "enp16s0";
      };
      lab = {
        id = 1099;
        interface = "enp16s0";
      };
      labadm = {
        id = 2995;
        interface = "enp16s0";
      };
    };
    interfaces = {
      enp16s0.useDHCP = true;
      adm.useDHCP = true;
      lab.useDHCP = true;
      labadm = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "10.1.99.10";
            prefixLength = 24;
          }
        ];
      };
    };
    firewall.enable = false;
  };

  # systemd.network.networks."40-br0" = {
  #   name = "br0";
  #   DHCP = "ipv4";
  #   dhcpV4Config = {
  #     UseDomains = true;
  #   };
  # };

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
          RouteMetric = 4096;
        };
        linkConfig.RequiredForOnline = "no";
      };
      "40-labadm" = {
        name = "labadm";
        dhcpV4Config = {
          RouteMetric = 4096;
        };
        linkConfig.RequiredForOnline = "no";
      };
    };
  };

  services = {
    udev.extraRules = ''
      # NOTE: prevent keyboard from continously going to sleep...
      ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTR{idVendor}=="cb10", ATTR{idProduct}=="1257", ATTR{power/control}="on"
    '';

    resolved = {
      enable = true;
      dnssec = "false";
      extraConfig = ''
        DNSStubListener=no
      '';
    };

    # Custom schedulers for gaming
    scx = {
      enable = true;
      scheduler = "scx_lavd";
    };

    hardware.openrgb.enable = true;

    fwupd.enable = true;
    smartd.enable = true;
    thermald.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  environment.variables.AMD_VULKAN_ICD = "RADV";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
