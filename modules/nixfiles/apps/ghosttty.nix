{
  nf.apps.ghostty = {
    homeManager =
      { pkgs, lib, ... }:
      let
        inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
      in
      {
        programs.ghostty = {
          enable = true;
          package = lib.mkIf isDarwin pkgs.ghostty-bin;
          settings = {
            auto-update = "off";

            macos-option-as-alt = true;

            keybind = [
              "ctrl+shift+h=goto_split:left"
              "ctrl+shift+j=goto_split:bottom"
              "ctrl+shift+k=goto_split:top"
              "ctrl+shift+l=goto_split:right"
            ];
          };
          systemd.enable = isLinux;
        };
      };
  };
}
