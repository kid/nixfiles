{
  inputs,
  lib,
  den,
  nf,
  ...
}:
{
  den.aspects.kid = {
    includes = [
      den._.define-user
      den._.primary-user
      nf.batteries.privileged-user
      nf.apps._
      nf.shell.zsh
      # nf.ai.pi
      nf.desktop.xremap
      nf.desktop.xremap.kde
      nf.desktop.plasma
      (den.provides.unfree [
        "1password"
        "1password-cli"
        "discord"
        "improved-tube"
        "onepassword-password-manager"
        "steam"
        "steam-unwrapped"
        "xone-dongle-firmware"
        "winbox"
      ])
    ];

    homeManager =
      {
        config,
        pkgs,
        osConfig,
        ...
      }:
      {
        imports = [ inputs.sops-nix.homeManagerModules.sops ];

        home = {
          inherit (osConfig.system) stateVersion;
          packages = [
            pkgs.opencode
            pkgs.my-neovim
            pkgs.winbox4
            pkgs.fd
            pkgs.htop
            pkgs.jq
            pkgs.yq
            pkgs.ripgrep
            pkgs.pistol
            pkgs.gnumake
            pkgs.gopls
            pkgs.devenv
            pkgs.kubectl
            pkgs.talosctl
            pkgs.flux
            # Work around upstream dagger packages still using the deprecated
            # `system` alias by passing the host platform system explicitly.
            (pkgs.callPackage "${inputs.dagger}/pkgs/container-use/default.nix" {
              inherit (pkgs.stdenv.hostPlatform) system;
            })
            (pkgs.callPackage "${inputs.dagger}/pkgs/dagger/default.nix" {
              inherit (pkgs.stdenv.hostPlatform) system;
            })
            pkgs.xclip
            pkgs.chromium
            pkgs.discord
            pkgs.telegram-desktop
            pkgs.nfs-utils
            pkgs.pulsemixer
            pkgs.freecad
            pkgs.prusa-slicer
            pkgs.proton-pass
          ];

          sessionVariables.EDITOR = "nvim";
          shellAliases.vimdiff = "nvim -d";
        };

        systemd.user.startServices = lib.mkDefault "sd-switch";

        programs = {

          htop.enable = true;
          btop.enable = true;
          bottom.enable = true;
          k9s.enable = true;
          lf.enable = true;
          kitty.enable = true;
          zellij.enable = true;

          ssh = {
            enable = true;
            enableDefaultConfig = false;
            matchBlocks."*" = {
              compression = true;
              forwardAgent = true;
            };
          };

          ghostty = {
            enable = true;
            settings.keybind = [
              "ctrl+shift+h=goto_split:left"
              "ctrl+shift+j=goto_split:bottom"
              "ctrl+shift+k=goto_split:top"
              "ctrl+shift+l=goto_split:right"
            ];
          };

          zed-editor = {
            enable = true;
            userSettings.vim_mode = true;
          };
        };

        xdg = {
          enable = true;
          mimeApps = {
            enable = true;
            associations.added = {
              "application/json" = [ "nvim.desktop" ];
              "text/english" = [ "nvim.desktop" ];
              "text/plain" = [ "nvim.desktop" ];
              "text/x-makefile" = [ "nvim.desktop" ];
              "text/x-c++hdr" = [ "nvim.desktop" ];
              "text/x-c++src" = [ "nvim.desktop" ];
              "text/x-chdr" = [ "nvim.desktop" ];
              "text/x-csrc" = [ "nvim.desktop" ];
              "text/x-java" = [ "nvim.desktop" ];
              "text/x-moc" = [ "nvim.desktop" ];
              "text/x-pascal" = [ "nvim.desktop" ];
              "text/x-tcl" = [ "nvim.desktop" ];
              "text/x-tex" = [ "nvim.desktop" ];
              "application/x-shellscript" = [ "nvim.desktop" ];
              "text/x-c" = [ "nvim.desktop" ];
              "text/x-c++" = [ "nvim.desktop" ];
              "video/*" = [ "mpv.desktop" ];
              "audio/*" = [ "mpv.desktop" ];
              "text/html" = [ "firefox.desktop" ];
              "x-scheme-handler/http" = [ "firefox.desktop" ];
              "x-scheme-handler/https" = [ "firefox.desktop" ];
              "x-scheme-handler/ftp" = [ "firefox.desktop" ];
              "x-scheme-handler/about" = [ "firefox.desktop" ];
              "x-scheme-handler/unknown" = [ "firefox.desktop" ];
              "x-scheme-handler/discord" = [ "Discord.desktop" ];
            };
            defaultApplications = config.xdg.mimeApps.associations.added;
          };
          autostart = {
            enable = true;
            entries = [
              "${pkgs._1password-gui}/share/applications/1password.desktop"
              "${pkgs.telegram-desktop}/share/applications/org.telegram.desktop.desktop"
            ];
          };
        };
      };
  };
}
