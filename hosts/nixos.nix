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
    # kernelParams = [ "boot.shell_on_fail" "modset=1" "fbdev=1" "hdmi_deepcolor=1" ];
    # kernelParams = [ "boot.shell_on_fail" "amdgpu.freesync_video=1" ];
    kernelParams = [ "boot.shell_on_fail" ];

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

  # services.xserver.videoDrivers = ["amdgpu"];
  services.xserver.videoDrivers = ["modesetting" "amdgpu"];

  hardware.opengl = {
    enable = true;
    # driSupport32Bit = true;
    # extraPackages32 = with pkgs.pkgsi686Linux; [ libva pipewire ];
    setLdLibraryPath = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl 
    ];
  };

  environment.systemPackages = [ pkgs.vulkan-validation-layers ];
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  boot.loader.systemd-boot.extraEntries = {
    "archlinux.conf" = ''
      title   Arch Linux
      linux   /vmlinuz-linux-zen
      initrd  /initramfs-linux-zen.img
      options root="LABEL=archlinux" rw
    '';
  };
}
