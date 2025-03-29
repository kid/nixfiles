{
  self,
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
      ./disko-config.nix
    ];

  facter.reportPath = ./facter.json;

  nixfiles = {
    device.profiles = [
      "server"
      "headless"
    ];
    roles.hercules-ci.enable = true;
    security.sops.defaultSopsFile = "${self}/secrets/pve0/default.sops.yaml";
    virtualisation.incus.enable = true;
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

  networking = {
    useDHCP = false;

    bridges.br0.interfaces = [
      "enp38s0"
      "enp39s0"
      "enp36s0f0"
      "enp36s0f1"
    ];

    interfaces.br0.useDHCP = true;
  };
}
