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
  ];

  system.stateVersion = "22.11";

  facter.reportPath = ./facter.json;

  nixfiles = {
    device.profiles = [
      "desktop"
      "graphical"
    ];

    system.boot.secureBoot = true;

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

    storage = {
      type = "btrfs";
      # mainDevice = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_1TB_S5GXNG0NB01573T";
      # mainDevice = "/dev/disk/by-id/nvme-Samsung_SSD_950_PRO_256GB_S2GLNCAGB17031B";
      mainDevice = "/dev/disk/by-id/nvme-WD_BLACK_SN8100_2000GB_25264U800487";
      impermanence = {
        enable = true;
        persistence."/persist/system".directories = [
          "/etc/NetworkManager/system-connections"
          "/var/lib/iwd"
          "/var/lib/fprint"
        ];
      };
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
  };

  networking = {
    hostId = "9371deb4";
    # useDHCP = false;
    useNetworkd = true;
    bridges = {
      br0 = {
        interfaces = [ "enp15s0" ];
      };
    };
    interfaces = {
      enp15s0.useDHCP = false;
      br0.useDHCP = true;
      adm.useDHCP = true;
      lab.useDHCP = true;
      # lab1.ipv4.addresses = [
      #   {
      #     address = "192.168.88.10";
      #     prefixLength = 24;
      #   }
      # ];
    };
    vlans = {
      adm = {
        id = 99;
        interface = "enp15s0";
      };
      lab = {
        id = 1991;
        interface = "enp15s0";
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
}
