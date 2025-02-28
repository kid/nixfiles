# { inputs, ... }:
# {
#   imports =
#     (with inputs.nixos-hardware.nixosModules; [
#       common-pc
#       common-pc-ssd
#       common-cpu-amd-pstate
#       common-cpu-amd-zenpower
#       common-gpu-amd
#     ])
#     ++ [
#       ./disko-config.nix
#     ];
#
#   nixfiles = {
#     hardware.cpu.amd.enable = true;
#     system = {
#       boot.enable = true;
#       realtime.enable = true;
#     };
#     theme.stylix.enable = true;
#   };
#
#   disko.devices.disk.main.imageSize = "10G";
#
#   hardware.enableRedistributableFirmware = true;
#
#   system.stateVersion = "25.05";
# }
{
  config,
  inputs,
  modulesPath,
  pkgs,
  ...
}:
let
  # kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  kernelPackages = pkgs.linuxPackages_cachyos;
in
# kernelPackages = pkgs.linuxKernel.packages.linux_6_11;
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    # inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default
    # inputs.stylix.nixosModules.stylix
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

  powerManagement = {
    enable = true;
  };

  chaotic = {
    hdr = {
      # enable = true;
      specialisation.enable = false;
    };
    # mesa-git.enable = true;
  };
  fileSystems = {

    # services.xserver.xrandrHeads = [
    #   {
    #     output = "HDMI-1";
    #     monitorConfig = ''Option "Enable" "false"'';
    #   }
    #   {
    #     output = "DP-3";
    #     primary = true;
    #   }
    # ];
    #
    # programs.steam.gamescopeSession.args = [ "-O" "DP-3" "-r" "138" ];

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

    xserver.videoDrivers = [
      "modesetting"
      "amdgpu"
    ];

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

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ amdvlk ];

    enable32Bit = true;
    extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
  };

  environment.variables.AMD_VULKAN_ICD = "RADV";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
