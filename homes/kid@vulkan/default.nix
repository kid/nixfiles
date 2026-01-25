{ nixfiles, pkgs, ... }:
{
  imports = [
    "${nixfiles}/legacy/modules/home-manager"
    "${nixfiles}/legacy/modules/home-manager/desktop.nix"
    "${nixfiles}/legacy/modules/home-manager/plasma.nix"
  ];

  nixfiles = {
    packages = {
      inherit (pkgs) incus opencode ollama;
    };

    services.xremap.enable = true;

    programs.gui.enable = true;
  };
}
