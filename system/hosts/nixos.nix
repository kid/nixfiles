{ modulesPath, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.resumeDevice = "/dev/disk/by-label/swap";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/46740fe8-a0ea-4b77-9dfc-525bc2293a2b";
      fsType = "btrfs";
      options = [ "subvol=nixos" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/48D3-2589";
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
}
