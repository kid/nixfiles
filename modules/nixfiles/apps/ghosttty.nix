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
            macos-titlebar-style = "tabs";

            keybind = [
              "ctrl+shift+h=goto_split:left"
              "ctrl+shift+j=goto_split:bottom"
              "ctrl+shift+k=goto_split:top"
              "ctrl+shift+l=goto_split:right"
            ]
            # smart-splits.nvim backend-ghostty (macOS only: it drives Ghostty over
            # AppleScript). Ghostty handles these until Neovim claims the `nvim`
            # key table, which forwards the keys to Neovim instead.
            ++ lib.optionals isDarwin [
              "performable:ctrl+h=goto_split:left"
              "performable:ctrl+j=goto_split:down"
              "performable:ctrl+k=goto_split:up"
              "performable:ctrl+l=goto_split:right"
              "performable:alt+h=resize_split:left,30"
              "performable:alt+j=resize_split:down,30"
              "performable:alt+k=resize_split:up,30"
              "performable:alt+l=resize_split:right,30"

              "nvim/"
              "nvim/ctrl+h=text:\\x08"
              "nvim/ctrl+j=text:\\x0a"
              "nvim/ctrl+k=text:\\x0b"
              "nvim/ctrl+l=text:\\x0c"
              "nvim/alt+h=esc:h"
              "nvim/alt+j=esc:j"
              "nvim/alt+k=esc:k"
              "nvim/alt+l=esc:l"
            ];
          };

          systemd.enable = isLinux;
        };
      };
  };
}
