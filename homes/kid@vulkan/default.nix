{
  lib,
  pkgs,
  ...
}:
{
  imports = [ ../common.nix ];

  home.packages = lib.mkBefore [
    pkgs.incus
    pkgs.ollama-rocm
  ];
}
