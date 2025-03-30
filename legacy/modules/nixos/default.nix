{
  imports = [
    # ./xremap.nix
  ];

  security.sudo.wheelNeedsPassword = false;
  services.openssh.enable = true;

  # always keep a reference to the source flake that generated each generations
  # environment.etc."current-nixos".source = ./.;

  # system.nixos.label =
  #   (builtins.concatStringsSep "-" (builtins.sort (x: y: x < y) config.system.nixos.tags))
  #   + "${config.system.nixos.version}.${self.sourceInfo.shortRev or "dirty"}";
}
