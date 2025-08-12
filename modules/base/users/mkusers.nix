{
  lib,
  self,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkDefault;
  inherit (lib.attrsets) genAttrs;
  inherit (self.lib.hardware) ldTernary;
  inherit (self.lib.validators) ifTheyExist;
in
{
  users.users = genAttrs config.nixfiles.system.users (
    name:
    let
      hm = config.home-manager.users.${name};
    in
    {
      home = "/" + (ldTernary pkgs "home" "Users") + "/" + name;
      shell = hm.nixfiles.programs.${hm.nixfiles.programs.defaults.shell}.package;
    }
    // (ldTernary pkgs {
      uid = mkDefault 1000;
      isNormalUser = true;
      initialPassword = mkDefault "foo";

      # only add groups that exist
      extraGroups = [
        "wheel"
        "nix"
      ]
      ++ ifTheyExist config [
        "network"
        "networkmanager"
        "systemd-journal"
        "audio"
        "pipewire" # this give us access to the rt limits
        "video"
        "input"
        "plugdev"
        "lp"
        "tss"
        "power"
        "wireshark"
        "mysql"
        "docker"
        "podman"
        "git"
        "libvirtd"
        "cloudflared"
        # FIXME: requirement for xremap
        "uinput"
        "gamemode"
        "corectrl"
      ];
    } { })
  );
}
