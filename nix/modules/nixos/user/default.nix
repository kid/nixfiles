{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.${namespace}) mkOpt;

  cfg = config.${namespace}.user;
in
{
  options.${namespace}.user = with types; {
    name = mkOpt str "kid" "The name of the user account.";
    fullName = mkOpt str "Arnaud Rebts" "The full name of the user.";
    initialPassword = mkOpt str "password" "The initial password of the user account.";
    extraGroups = mkOpt (listOf str) [ ] "Groups for the user to be assigned.";
    extraOptions = mkOpt attrs { } "Extra options passed to <option>users.users.<name></option>.";
  };

  config = {
    environment.pathsToLink = [ "/share/zsh" ];

    programs.zsh = {
      enable = true;
      autosuggestions.enable = true;
    };

    users.users.${cfg.name} = {
      inherit (cfg) name initialPassword;

      group = "users";
      home = "/home/${cfg.name}";
      isNormalUser = true;
      shell = pkgs.zsh;
      uid = 1000;

      extraGroups = [
        "wheel"
        "systemd-journal"
        "audio"
        "video"
        "plugdev"
        "lp"
        "power"
        "nix"
      ] ++ cfg.extraGroups;
    } // cfg.extraOptions;
  };
}
