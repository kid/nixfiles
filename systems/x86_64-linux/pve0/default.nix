{
  inputs,
  ...
}:
{
  imports =
    (with inputs.nixos-hardware.nixosModules; [
      common-pc
      common-pc-ssd
      # common-cpu-amd
      # common-cpu-amd-pstate
      # common-cpu-amd-zenpower
    ])
    ++ [
      # "${modulesPath}/installer/scan/not-detected.nix"
      ./disko-config.nix
    ];

  facter.reportPath = ./facter.json;

  nixfiles = {
    archetypes.server.enable = true;
    # hardware.cpu.amd.enable = true;
  };

  disko.devices.disk.main.imageSize = "10G";

  system.stateVersion = "25.05";

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
  };
}
