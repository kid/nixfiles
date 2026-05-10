{
  inputs,
  lib,
  ...
}:
{
  den.aspects.base.nixos =
    { config, pkgs, ... }:
    {
      imports = [
        inputs.home-manager.nixosModules.default
        inputs.disko.nixosModules.disko
        inputs.impermanence.nixosModules.impermanence
        inputs.preservation.nixosModules.preservation
        inputs.stylix.nixosModules.stylix
        inputs.ucodenix.nixosModules.default
        inputs.sops-nix.nixosModules.sops
        inputs.xremap.nixosModules.default
        inputs.nur.modules.nixos.default
        inputs.chaotic.nixosModules.default
        inputs.nix-gaming.nixosModules.wine
        inputs.nix-gaming.nixosModules.pipewireLowLatency
        inputs.nix-gaming.nixosModules.platformOptimizations
        inputs.lanzaboote.nixosModules.lanzaboote
      ];

      nixpkgs = {
        overlays = [
          inputs.nur.overlays.default
        ];

        config = {
          allowUnfree = true;
          allowBroken = false;
          allowAliases = false;
        };
      };

      users.users.kid = {
        uid = lib.mkDefault 1000;
        isNormalUser = true;
        initialPassword = lib.mkDefault "foo";
        home = "/home/kid";
        shell = pkgs.zsh;
        extraGroups = [
          "wheel"
          "nix"
          "systemd-journal"
          "audio"
          "pipewire"
          "video"
          "input"
          "lp"
          "docker"
          "gamemode"
        ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBx9vvChkupOOoETU4Y1hv+469DFV0TdEVdONeqfXn04 kid@nixos"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAcnmLrPeTJeKsasfU0qn4sP4lBNeOUgRG4iZDS8nyEo kid@vulkan"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHIM3nsk3HxvEcplSqwynh9V2NzlYdI10mrR746SiJZb kid@fw13"
        ];
      };

      environment = {
        defaultPackages = lib.mkForce [ ];
        systemPackages = with pkgs; [
          git
          curl
          dnsutils
          usbutils
          ethtool
          lshw
          pciutils
          rsync
          util-linux
          btop
          htop
          watch
          libqalculate
          wl-clipboard-rs
          mangohud
          umu-launcher
          protonup-qt
          powertop
          s-tui
          efibootmgr
          efitools
          efivar
        ];

        variables = {
          NIXPKGS_CONFIG = lib.mkForce "";
          NIXOS_OZONE_WL = "1";
          _JAVA_AWT_WM_NONEREPARENTING = "1";
          GDK_BACKEND = "wayland,x11";
          ANKI_WAYLAND = "1";
          MOZ_ENABLE_WAYLAND = "1";
          XDG_SESSION_TYPE = "wayland";
          SDL_VIDEODRIVER = "wayland";
          CLUTTER_BACKEND = "wayland";
        };

        sessionVariables = {
          MESA_VK_WSI_PRESENT_MODE = "immediate";
          KWIN_DRM_NO_AMS = "1";
          PROTON_ENABLE_WAYLAND = "1";
          PROTON_ENABLE_HDR = "1";
          PROTON_USE_NTSYNC = 1;
          SDL_VIDEODRIVER = "wayland";
        };

        pathsToLink = [
          "/share/bash-completion"
          "/share/zsh"
        ];
      };

      i18n.defaultLocale = "en_NZ.UTF-8";

      time.timeZone = "Europe/Brussels";

      nix = {
        package = pkgs.nixVersions.latest;

        gc = {
          automatic = true;
          options = "--delete-older-than 3d";
          dates = "Mon *-*-* 03:00";
        };

        channel.enable = false;

        optimise = {
          automatic = true;
          dates = [ "04:00" ];
        };

        daemonCPUSchedPolicy = "idle";
        daemonIOSchedClass = "idle";
        daemonIOSchedPriority = 7;

        settings = {
          min-free = 5 * 1024 * 1024 * 1024;
          max-free = 20 * 1024 * 1024 * 1024;
          allowed-users = [ "@wheel" ];
          trusted-users = [ "@wheel" ];
          use-registries = true;
          flake-registry = "";
          max-jobs = "auto";
          sandbox = true;
          system-features = [
            "nixos-test"
            "kvm"
            "recursive-nix"
            "big-parallel"
          ];
          keep-going = true;
          log-lines = 30;
          experimental-features = [
            "flakes"
            "nix-command"
            "recursive-nix"
            "ca-derivations"
            "auto-allocate-uids"
            "cgroups"
            "pipe-operators"
            "fetch-closure"
            "dynamic-derivations"
            "parse-toml-timestamps"
          ];
          warn-dirty = false;
          http-connections = 50;
          accept-flake-config = false;
          allow-import-from-derivation = true;
          keep-derivations = true;
          keep-outputs = true;
          use-xdg-base-directories = true;
          use-cgroups = true;
          substituters = [
            "https://kidibox.cachix.org"
            "https://nix-community.cachix.org"
            "https://devenv.cachix.org"
            "https://nix-gaming.cachix.org"
          ];
          trusted-public-keys = [
            "kidibox.cachix.org-1:BN875x9JUW61souPxjf7eA5Uh2k3A1OSA1JIb/axGGE="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
            "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
          ];
        };
      };

      programs = {
        zsh.enable = true;

        nh = {
          enable = true;
          clean = {
            enable = false;
            dates = "weekly";
          };
        };

        nix-ld.enable = true;

        _1password.enable = true;
        _1password-gui = {
          enable = true;
          polkitPolicyOwners = [ "kid" ];
        };

        steam = {
          enable = true;
          extraCompatPackages = with pkgs; [
            proton-ge-bin
            proton-cachyos_x86_64_v4
            proton-cachyos_nightly_x86_64_v4
          ];
          package = pkgs.steam.override {
            extraPkgs =
              pkgs': with pkgs'; [
                mangohud
                gamemode
                libxcursor
                libxi
                libxinerama
                libxscrnsaver
                libpng
                libpulseaudio
                libvorbis
                stdenv.cc.cc.lib
                libkrb5
                keyutils
              ];
          };
          platformOptimizations.enable = true;
        };

        gamescope = {
          enable = true;
          capSysNice = true;
          args = [
            "--rt"
            "--expose-wayland"
          ];
        };

        gamemode = {
          enable = true;
          enableRenice = true;
          settings = {
            general = {
              softrealtime = "auto";
              renice = 10;
            };
            custom = {
              start = "${pkgs.libnotify}/bin/notify-send -a 'Gamemode' 'Optimizations activated'";
              end = "${pkgs.libnotify}/bin/notify-send -a 'Gamemode' 'Optimizations deactivated'";
            };
          };
        };

        wine = {
          enable = true;
          ntsync = true;
        };

        kdeconnect.enable = true;
      };

      security = {
        sudo = {
          enable = true;
          wheelNeedsPassword = lib.mkDefault false;
          execWheelOnly = true;
          extraConfig = ''
            Defaults lecture = never
            Defaults pwfeedback
            Defaults env_keep += "EDITOR PATH DISPLAY"
            Defaults timestamp_timeout = 300
          '';
        };

        pam.services.sddm.kwallet.enable = true;
        rtkit.enable = true;
      };

      sops = {
        defaultSopsFile = null;
        age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      };

      services = {
        resolved.enable = true;

        openssh = {
          enable = true;
          startWhenNeeded = true;
          allowSFTP = true;
          settings.PermitRootLogin = "no";
          openFirewall = true;
        };

        displayManager.sddm = {
          enable = true;
          wayland.enable = true;
          settings.General.InputMethod = "";
        };

        desktopManager.plasma6 = {
          enable = true;
          enableQt5Integration = false;
        };

        printing = {
          enable = true;
          drivers = [ pkgs.brlaser ];
        };

        avahi = {
          enable = true;
          nssmdns4 = true;
          openFirewall = true;
        };

        pipewire = {
          enable = true;
          alsa.enable = true;
          audio.enable = true;
          jack.enable = true;
          pulse.enable = true;
          wireplumber.enable = true;
          lowLatency.enable = true;
        };

        pulseaudio.enable = lib.mkForce false;
        power-profiles-daemon.enable = true;

        btrfs.autoScrub = {
          enable = true;
          fileSystems = [ "/" ];
          interval = "weekly";
        };
      };

      boot = {
        consoleLogLevel = 3;
        kernelPackages = pkgs.linuxPackages_latest;
        kernelParams = [
          "quiet"
          "splash"
          "vt.global_cursor_default=0"
          "quiet"
          "udev.log_level=3"
          "rd.udev.log_level=3"
          "systemd.show_status=auto"
          "rd.systemd.show_status=auto"
          "fbcon=nodefer"
        ];

        kernel.sysctl = {
          "kernel.nmi_watchdog" = 0;
          "vm.dirty_writeback_centisecs" = 1500;
        };

        initrd = {
          systemd.enable = true;
          verbose = true;
          supportedFilesystems.btrfs = true;
        };

        supportedFilesystems.btrfs = true;

        loader = {
          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot";
          };

          systemd-boot = {
            configurationLimit = 3;
            consoleMode = "max";
            extraInstallCommands = ''
              ${pkgs.gnused}/bin/sed -E -i 's/default nixos-generation-[0-9]+\.conf/default @saved/g' /boot/loader/loader.conf
            '';
          };
        };

        plymouth.enable = true;

        tmp = {
          useTmpfs = lib.mkDefault false;
          cleanOnBoot = lib.mkDefault (!config.boot.tmp.useTmpfs);
          tmpfsSize = lib.mkDefault "50%";
        };
      };

      hardware = {
        enableRedistributableFirmware = true;
        xone.enable = true;
        bluetooth.enable = true;
        printers = {
          ensureDefaultPrinter = "Brother_HL-2030_series";
          ensurePrinters = [
            {
              name = "Brother_HL-2030_series";
              deviceUri = "http://10.0.100.137:631/printers/Brother_HL-2030_series";
              model = "drv:///brlaser.drv/brl2320d.ppd";
              ppdOptions.PageSize = "A4";
            }
          ];
        };
      };

      powerManagement.scsiLinkPolicy = "med_power_with_dipm";

      stylix = {
        enable = true;
        image = ./theme/stylix/gruvbox-dark-rainbow.png;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
        fonts = {
          monospace = {
            name = "JetBrainsMono Nerd Font Propo";
            package = pkgs.nerd-fonts.jetbrains-mono;
          };
          sizes.terminal = lib.mkDefault 11;
        };
        polarity = "dark";
        targets.qt.enable = false;
      };
    };
}
