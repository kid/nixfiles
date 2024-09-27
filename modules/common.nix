{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [ ./primary.nix ];

  user = {
    home = "${if pkgs.stdenvNoCC.isDarwin then "/Users" else "/home"}/${config.user.name}";
    shell = pkgs.zsh;
  };

  hm = import ./home-manager;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [
      inputs.xremap.homeManagerModules.default
      inputs.plasma-manager.homeManagerModules.plasma-manager
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      watch
      libqalculate
      dig
      devenv
      # coreutils-full
    ];
  };

  programs.zsh = {
    enable = true;

    # Don't run compinit as home-manager will already take care of it, otherwise this cause a slow start
    enableCompletion = false;
  };
}
