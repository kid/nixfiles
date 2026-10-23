{
  inputs,
  lib,
  den,
  nf,
  ...
}:
{
  den.aspects.kid = { host, ... }: {
    includes = [
      den._.define-user
      den._.primary-user
      nf.batteries.privileged-user
      nf.apps._
      nf.shell.zsh
      nf.ai
      nf.ai._
      nf.desktop
      nf.desktop.xremap
      nf.desktop.plasma
      nf.games.kitten-space-agency
      nf.dev.arduino
    ]
    ++ (if host.name == "vulkan" then [ nf.games.helldivers2 ] else [ ]);

    homeManager =
      {
        pkgs,
        osConfig,
        self',
        ...
      }:
      {
        imports = [ inputs.sops-nix.homeManagerModules.sops ];

        home = {
          inherit (osConfig.system) stateVersion;
          packages = [
            pkgs.winbox4
            pkgs.pistol
            pkgs.gnumake
            pkgs.gopls
            pkgs.devenv
            pkgs.kubectl
            pkgs.talosctl
            pkgs.flux
            self'.packages.dagger
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
            settings."*" = {
              Compression = true;
              ForwardAgent = true;
            };
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

        home.sessionVariables = {
          PROTON_FSR4_RDNA3_UPGRADE = "1";
          PROTON_USE_OPTISCALER = "1";
        };
      };
    };
  };
}
