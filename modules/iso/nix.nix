{ self, config, ... }:
{
  imports = [
    "${self}/modules/base/nix/substituers.nix"
  ];

  nix = {
    channel.enable = false;

    nixPath = [ "nixpkgs=${config.nix.registry.nixpkgs.to.path}" ];

    settings = {
      experimental-features = [
        "flakes"
        "nix-command"
      ];
    };
  };
}
