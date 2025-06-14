{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
{
  imports = [
    # (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    # inputs.nixos-hardware.nixosModules.common-cpu-amd
    # inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    # inputs.nixos-hardware.nixosModules.common-gpu-amd
  ];

  system.stateVersion = "22.11";

  facter.reportPath = ./facter.json;

  nixfiles = {
    device.profiles = [
      "desktop"
      "graphical"
    ];

    programs = {
      gaming.enable = true;
    };

    services = {
      printing.enable = true;
    };

    virtualisation = {
      enable = true;
      docker.enable = true;
    };

    system.boot.kernel = latestKernelPackage;

    packages = {
      inherit (pkgs) go;
    };
  };

  boot = {
    resumeDevice = "/dev/disk/by-label/swap";

    # blacklistedKernelModules = [ "r8169" ];

    extraModulePackages = with config.boot.kernelPackages; [
      r8125
      # r8168
    ];

    kernelParams = [
      "boot.shell_on_fail"
      "amdgpu.dcdebugmask=0x400"
      "preempt=full"
      "amd_pstate=active"
    ];

    initrd.supportedFilesystems = [ "zfs" ];

    supportedFilesystems = [
      "zfs"
      "ntfs"
    ];

    zfs = {
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
    # useDHCP = false;
    useNetworkd = true;
    bridges = {
      br0 = {
        interfaces = [ "enp16s0" ];
      };
    };
    interfaces = {
      enp16s0.useDHCP = false;
      br0.useDHCP = true;
      adm.useDHCP = true;
    };
    vlans = {
      adm = {
        id = 99;
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
    };
  };

  services = {
    # NOTE: prevent keyboard from continously going to sleep...
    udev.extraRules = lib.mkAfter ''
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

  environment.variables.AMD_VULKAN_ICD = "RADV";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

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
  ];
}
