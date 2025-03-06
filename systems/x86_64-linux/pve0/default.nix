{
  lib,
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
    roles.hercules-ci.enable = true;
    security.sops.defaultSopsFile = lib.snowfall.fs.get-file "secrets/pve0/default.sops.yaml";
  };

  # sops.secrets."hercules_ci/caches".sopsFile =
  #   lib.snowfall.fs.get-file "secrets/pve0/hercules_ci_caches.sops.json";

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
