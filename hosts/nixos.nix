{ modulesPath, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.resumeDevice = "/dev/disk/by-label/swap";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.tmpOnTmpfs = true;

  boot.initrd.supportedFilesystems = ["zfs"];
  boot.zfs.devNodes = "/dev/disk/by-id";

  fileSystems."/" =
    {
      device = "zfs/SYSTEM/root";
      fsType = "zfs";
      options = [ "zfsutil" ];
      neededForBoot = true;
    };

  fileSystems."/var" =
    {
      device = "zfs/SYSTEM/var";
      fsType = "zfs";
      options = [ "zfsutil" ];
      neededForBoot = true;
    };

  fileSystems."/nix" =
    {
      device = "zfs/LOCAL/nix";
      fsType = "zfs";
      options = [ "zfsutil" ];
    };

  fileSystems."/home" =
    {
      device = "rpool/USER/home";
      fsType = "zfs";
      options = [ "zfsutil" ];
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

  networking.hostId = "9371deb4";
  networking.useDHCP = false;
  networking.useNetworkd = true;
  networking.interfaces.enp5s0.useDHCP = true;

  services.resolved.enable = true;
  services.resolved.dnssec = "false";

  services.xserver = {
    videoDrivers = [ "nvidia" ];
    displayManager = {
      setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output DP-4 --scale 1x1 --mode 3840x1600 --rate 144 --pos 0x0 --primary
        ${pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --scale 1x1 --mode 2560x1440 --rate 144 --pos 3840x-480 --rotate left
      '';
    };
  };

  hardware.opengl = {
    driSupport32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [ libva pipewire ];
    setLdLibraryPath = true;
  };
}
