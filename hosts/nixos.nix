{ config, modulesPath, pkgs, ... }:
let
  kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    inherit kernelPackages;
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    resumeDevice = "/dev/disk/by-label/swap";

    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    kernelModules = [ "nct6775" ];
    kernelParams = [ "boot.shell_on_fail" "modset=1" "fbdev=1" "hdmi_deepcolor=1" ];

    tmp.useTmpfs = true;

    initrd.supportedFilesystems = [ "zfs" ];
    zfs.enableUnstable = true;
    zfs.devNodes = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_1TB_S5GXNG0NB01573T-part5";

  };
  fileSystems."/" =
    {
      device = "rpool/SYSTEM/root";
      fsType = "zfs";
      options = [ "zfsutil" ];
      neededForBoot = true;
    };

  fileSystems."/var" =
    {
      device = "rpool/SYSTEM/var";
      fsType = "zfs";
      options = [ "zfsutil" ];
      neededForBoot = true;
    };

  fileSystems."/nix" =
    {
      device = "rpool/LOCAL/nix";
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

  networking = {
    hostId = "9371deb4";
    useDHCP = false;
    useNetworkd = true;
    bridges = {
      br0 = {
        interfaces = [ "enp5s0" ];
      };
    };
    firewall.enable = false;
  };

  systemd.network.networks."40-br0" = {
    name = "br0";
    DHCP = "ipv4";
    dhcpV4Config = {
      UseDomains = true;
    };
  };

  services.resolved.enable = true;
  services.resolved.dnssec = "false";

  services.xserver = {
    videoDrivers = [ "nvidia" ];
    # displayManager = {
    #   setupCommands = ''
    #     ${pkgs.xorg.xrandr}/bin/xrandr --listmonitors | grep DP-4 && ${pkgs.xorg.xrandr}/bin/xrandr --output DP-4 --scale 1x1 --mode 3840x1600 --rate 144 --pos 0x0 --primary
    #     ${pkgs.xorg.xrandr}/bin/xrandr --listmonitors | grep DP-2 && ${pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --scale 1x1 --mode 2560x1440 --rate 144 --pos 3840x-480 --rotate left
    #   '';
    # };
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    # package = kernelPackages.nvidiaPackages.beta;
    # nvidiaSettings = true;
  };

  hardware.opengl = {
    driSupport32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [ libva pipewire ];
    setLdLibraryPath = true;
    extraPackages = with pkgs; [
      vulkan-validation-layers
    ];
  };
}
