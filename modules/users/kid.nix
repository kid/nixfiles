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
      nf.desktop
      nf.desktop.xremap
      nf.desktop.xremap.kde
      nf.desktop.plasma
    ];

    homeManager =
      {
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
            pkgs.winbox4
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
        };

      };

    provides = {
      fw13.homeManager = {
        programs.plasma.input.touchpads = [
          {
            vendorId = "093A";
            productId = "0274";
            name = "PIXA3854:00 093A:0274 Touchpad";
            naturalScroll = true;
            tapToClick = false;
            rightClickMethod = "twoFingers";
            middleButtonEmulation = true;
          }
        ];
      };

      vulkan.homeManager = {
        programs.plasma.powerdevil.AC = {
          autoSuspend.action = "nothing";
          dimDisplay.enable = false;
          turnOffDisplay.idleTimeout = "never";
        };
      };
    };
  };
}
