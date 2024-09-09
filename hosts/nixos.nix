{
  self,
  # config,
  inputs,
  modulesPath,
  pkgs,
  ...
}:
let
  # kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
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
    inputs.hm.nixosModule
    inputs.nur.nixosModules.nur
    inputs.stylix.nixosModules.stylix
    inputs.chaotic.nixosModules.default
    ../modules/nixos
    ../modules/nixos/desktop.nix
    ../modules/nixos/games.nix
    ../modules/nixos/docker.nix
    ../modules/nixos/podman.nix
    ../modules/nixos/virtualization.nix
    ../modules/nixos/printing.nix
    ../profiles/plasma6.nix
  ];

  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnfree = true;
    };
    overlays = [
      self.overlays.stable-packages
      inputs.nur.overlay
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

    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    kernelModules = [ "nct6775" ];
    # kernelParams = [ "boot.shell_on_fail" "modset=1" "fbdev=1" "hdmi_deepcolor=1" ];
    # kernelParams = [ "boot.shell_on_fail" "amdgpu.freesync_video=1" ];
    kernelParams = [
      "boot.shell_on_fail"
      "quiet"
      "udev.log_level=0"
      "amd_state=guided"
    ];

    # tmp.useTmpfs = true;

    supportedFilesystems = [
      "zfs"
      "ntfs"
    ];
    initrd.supportedFilesystems = [ "zfs" ];
    # zfs.enableUnstable = true;
    zfs.devNodes = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_1TB_S5GXNG0NB01573T-part5";

    # plymouth.enable = true;
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil";
  };

  chaotic = {
    hdr = {
      # enable = true;
      specialisation.enable = false;
    };
    # mesa-git.enable = true;
  };

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

  fileSystems."/" = {
    device = "rpool/SYSTEM/root";
    fsType = "zfs";
    options = [ "zfsutil" ];
    neededForBoot = true;
  };

  fileSystems."/var" = {
    device = "rpool/SYSTEM/var";
    fsType = "zfs";
    options = [ "zfsutil" ];
    neededForBoot = true;
  };

  fileSystems."/nix" = {
    device = "rpool/LOCAL/nix";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/home" = {
    device = "rpool/USER/home";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
  };

  fileSystems."/var/lib/docker" = {
    device = "/dev/zvol/rpool/docker";
    fsType = "ext4";
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  networking = {
    hostId = "9371deb4";
    useDHCP = true;
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

  services.resolved = {
    enable = true;
    dnssec = "false";
    extraConfig = ''
      DNSStubListener=no
    '';
  };

  # services.xserver.videoDrivers = ["amdgpu"];
  services.xserver.videoDrivers = [
    "modesetting"
    "amdgpu"
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ amdvlk ];

    enable32Bit = true;
    extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
  };

  # environment.variables.AMD_VULKAN_ICD = "RADV";
  environment.variables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";

  # environment.sessionVariables.VK_LAYER_PATH = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";

  # environment.systemPackages =
  #   [ pkgs.vulkan-validation-layers pkgs.vulkan-hdr-layer ];

  systemd.tmpfiles.rules = [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];

  boot.loader.systemd-boot.extraEntries = {
    "archlinux.conf" = ''
      title   Arch Linux
      linux   /vmlinuz-linux-zen
      initrd  /initramfs-linux-zen.img
      options root="LABEL=archlinux" rw
    '';
  };

  services.hardware.openrgb.enable = true;

  services = {
    fwupd.enable = true;
    smartd.enable = true;
    thermald.enable = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # hardware.printers = {
  #   ensurePrinters = [
  #     {
  #       name = "Brother_HL-2030_series";
  #       # location = "Home";
  #       deviceUri = "http://10.0.100.137:631/printers/Brother_HL-2030_series";
  #       # model = "drv:///sample.drv/generic.ppd";
  #       ppdOptions = {
  #         PageSize = "A4";
  #       };
  #     }
  #   ];
  #   ensureDefaultPrinter = "Brother_HL-2030_series";
  # };
}
