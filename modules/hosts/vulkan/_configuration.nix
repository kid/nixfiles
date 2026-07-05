{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.kid = {
    extraGroups = lib.mkAfter [
      "libvirtd"
      "corectrl"
    ];
  };

  environment.systemPackages = lib.mkAfter (
    with pkgs;
    [
      virt-manager
      virt-viewer
      (pkgs.writeShellScriptBin "qemu-system-x86_64-uefi" ''
        qemu-system-x86_64 \
          -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
          "$@"
      '')
    ]
  );

  networking = {
    hostId = "9371deb4";
    useNetworkd = true;
    nftables.enable = true;

    interfaces = {
      k8s.useDHCP = false;
      adm.useDHCP = true;
      # lab-oob.useDHCP = true;
      # lab-trusted = {
      #   useDHCP = true;
      #   ipv4.routes = [
      #     {
      #       address = "10.128.0.0";
      #       prefixLength = 9;
      #       via = "10.128.100.1";
      #     }
      #   ];
      # };
    };

    vlans = {
      k8s = {
        id = 40;
        interface = "enp15s0";
      };
      adm = {
        id = 99;
        interface = "enp15s0";
      };
      # lab-oob = {
      #   id = 1991;
      #   interface = "enp15s0";
      # };
      # lab-trusted = {
      #   id = 1100;
      #   interface = "enp15s0";
      # };
    };

    bridges.br-k8s.interfaces = [ "k8s" ];
    interfaces.br-k8s.useDHCP = false;

    firewall = {
      enable = false;
      allowedTCPPorts = [ 8443 ];
    };
  };

  systemd = {
    network.networks = {
      "40-adm" = {
        name = "adm";
        dhcpV4Config.RouteMetric = 2048;
      };
      # "40-lab-oob" = {
      #   name = "lab-oob";
      #   dhcpV4Config.RouteMetric = 2048;
      # };
      # "40-lab-trusted" = {
      #   name = "lab-trusted";
      #   dhcpV4Config.RouteMetric = 2048;
      #   domains = [ "~dev.kidibox.net." ];
      # };
    };

    suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];

    services.systemd-machine-id-commit = {
      unitConfig.ConditionPathIsMountPoint = [
        ""
        "/persistent/etc/machine-id"
      ];
      serviceConfig.ExecStart = [
        ""
        "systemd-machine-id-setup --commit --root /persistent"
      ];
    };
  };

  programs = {
    gamescope.args = lib.mkAfter [
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

    corectrl.enable = true;
    virt-manager.enable = true;
  };

  services = {
    resolved.settings.Resolve = {
      DNSSEC = false;
      DNSStubListener = true;
    };

    displayManager.autoLogin = {
      enable = true;
      user = "kid";
    };

    udev.extraRules = lib.mkAfter ''
      ACTION=="add|change", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="on"
      ACTION=="add|change", SUBSYSTEM=="usb", TEST=="power/wakeup", ATTR{power/wakeup}="disabled"
      SUBSYSTEM=="ata_port", KERNEL=="ata*", ATTR{device/power/control}="auto"
      ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTR{idVendor}=="cb10", ATTR{idProduct}=="1257", ATTR{power/control}="on"
    '';

    scx = {
      enable = true;
      scheduler = "scx_lavd";
    };

    hardware.openrgb.enable = true;
    smartd.enable = true;
  };

  system.stateVersion = "22.11";

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ r8125 ];
    kernelParams = lib.mkAfter [
      "boot.shell_on_fail"
      "amdgpu.dcdebugmask=0x400"
      "preempt=full"
      "amd_pstate=active"
    ];

    initrd.systemd.services.rollback = {
      wantedBy = [ "initrd.target" ];
      after = [ "initrd-root-device.target" ];
      before = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /mnt
        mount -o subvol="@" /dev/disk/by-id/nvme-WD_BLACK_SN8100_2000GB_25264U800487-part2 /mnt
        btrfs subvolume delete /mnt/root
        btrfs subvolume create /mnt/root
        umount /mnt
      '';
    };

    binfmt.emulatedSystems = [ "aarch64-linux" ];

    loader.systemd-boot = {
      enable = true;
      windows."11".efiDeviceHandle = "HD0b";
    };
  };

  hardware = {
    amdgpu.overdrive.enable = true;
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };

  fileSystems = {
    "/persist".neededForBoot = true;
    "/home".neededForBoot = true;
  };

  virtualisation = {
    docker.enable = true;

    libvirtd = {
      enable = true;
      allowedBridges = [ "br-k8s" ];
      qemu.swtpm.enable = true;
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
}
