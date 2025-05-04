{ pkgs, inputs', ... }:
{
  programs.git.enable = true;

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      neovim
      pciutils
      ;

    inherit (inputs'.nixos-anywhere.packages) nixos-anywhere;
  };

  hardware.enableRedistributableFirmware = true;
}
