{
  config,
  inputs,
  modulesPath,
  pkgs,
  ...
}:
{
  imports =
    (with inputs.nixos-hardware.nixosModules; [
      common-pc
      common-pc-ssd
      common-cpu-amd
      common-cpu-amd-pstate
      common-cpu-amd-zenpower
    ])
    ++ [
      "${modulesPath}/installer/scan/not-detected.nix"
      ./disko-config.nix
    ];

  nixfiles = {
    hardware.cpu.amd.enable = true;
    system = {
      boot = {
        enable = true;
        silent = false;
        plymouth = false;
      };
      realtime.enable = true;
    };
    theme.stylix.enable = true;
  };

  disko.devices.disk.main.imageSize = "10G";

  hardware.enableRedistributableFirmware = true;

  system.stateVersion = "25.05";

  powerManagement = {
    cpuFreqGovernor = "powersave";
    powertop.enable = true;
  };

  environment.systemPackages =
    with pkgs;
    [
      htop
      ethtool
      pciutils
      powertop
    ]
    ++ (with config.boot.kernelPackages; [ cpupower ]);

  security.sudo.wheelNeedsPassword = false;

  boot.kernelParams = [
    "iommy=soft"
    "pcie_aspm.policy=powersave"
    "rcu_nocbs=all"
    "rcutree.enable_rcu_lazy=1"
  ];
  programs = {
    neovim.enable = true;
    nix-ld.enable = true;
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
      };
    };

    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="pci", ATTR{power/control}="auto"
      ACTION=="add", SUBSYSTEM=="scsi_host", KERNEL=="host*", ATTR{link_power_management_policy}="min_power"
      ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"
    '';

    auto-cpufreq.enable = true;
    thermald.enable = true;
  };
}
