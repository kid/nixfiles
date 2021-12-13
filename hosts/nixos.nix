{ modulesPath, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.resumeDevice = "/dev/disk/by-label/swap";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  fileSystems."/" =
    { device = "/dev/disk/by-label/linux";
      fsType = "btrfs";
      options = [ "subvol=@nixos/root" "compress=zstd" "noatime" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-label/linux";
      fsType = "btrfs";
      options = [ "subvol=@nixos/nix" "compress=zstd" "noatime" ];
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-label/linux";
      fsType = "btrfs";
      options = [ "subvol=@nixos/persist" "compress=zstd" "noatime" ];
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-label/linux";
      fsType = "btrfs";
      options = [ "subvol=@nixos/log" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-label/linux";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" "noatime" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/EFI";
      fsType = "vfat";
    };

  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];

  networking.useDHCP = false;
  networking.useNetworkd = true;
  networking.interfaces.enp5s0.useDHCP = true;

  services.resolved.enable = true;
  services.resolved.dnssec = "false";

  services.xserver = {
    videoDrivers = [ "nvidia" ];
    displayManager = {
      setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output DP-4 --scale 1x1 --mode 3840x1600 --rate 119.98 --pos 0x480 --primary
        ${pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --scale 1x1 --mode 2560x1440 --rate 119.98 --pos 3840x0 --rotate left
      '';
    };
  };

  hardware.opengl = {
    driSupport32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [ libva pipewire ];
    setLdLibraryPath = true;
  };
}
