{
  inputs,
  lib,
  ...
}:
{
  den.hosts.x86_64-linux.fw13 = {
    users.kid = { };
  };

  den.aspects.fw13.nixos =
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
        inputs.chaotic.nixosModules.default
        inputs.nix-gaming.nixosModules.wine
        inputs.nix-gaming.nixosModules.pipewireLowLatency
        inputs.nix-gaming.nixosModules.platformOptimizations
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.niri.nixosModules.niri
        inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
      ];

      nixpkgs = {
        overlays = with inputs; [
          nur.overlays.default
          niri.overlays.niri
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
          "networkmanager"
          "systemd-journal"
          "audio"
          "pipewire"
          "video"
          "input"
          "lp"
          "docker"
          "uinput"
          "gamemode"
          "realtime"
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
          fw-ectool
          wl-clipboard-rs
          mangohud
          umu-launcher
          protonup-qt
          powertop
          s-tui
          config.boot.kernelPackages.cpupower
          efibootmgr
          efitools
          efivar
          sbctl
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

        persistence."/persist/system" = {
          hideMounts = true;
          files = [
            "/etc/machine-id"
            "/etc/ssh/ssh_host_rsa_key"
            "/etc/ssh/ssh_host_rsa_key.pub"
            "/etc/ssh/ssh_host_ed25519_key"
            "/etc/ssh/ssh_host_ed25519_key.pub"
          ];
          directories = [
            "/var/lib/bluetooth"
            "/var/lib/fwupd"
            "/var/lib/nixos"
            "/var/lib/sddm"
            "/var/log"
            "/etc/NetworkManager/system-connections"
            "/var/lib/iwd"
            "/var/lib/fprint"
            "/var/lib/sbctl"
          ];
        };
      };

      fileSystems = {
        "/persist/system".neededForBoot = lib.mkForce true;
      };

      disko.devices.disk.main = {
        device = "/dev/disk/by-id/nvme-SHPP41-2000GM_ASD9N54741120A36G_1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              label = "boot";
              start = "1M";
              end = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            nixos = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [
                  "-L"
                  "nixos"
                  "-f"
                ];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/persist/system" = {
                    mountpoint = "/persist/system";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                };
              };
            };
          };
        };
      };

      virtualisation.vmVariantWithDisko = {
        disko.devices.disk.main.imageSize = "10G";
        virtualisation.fileSystems."/home".neededForBoot = true;
        virtualisation.fileSystems."/persist/system".neededForBoot = true;
      };

      i18n.defaultLocale = "en_NZ.UTF-8";

      time.timeZone = "Europe/Brussels";

      networking = {
        useNetworkd = lib.mkForce false;
        networkmanager.enable = lib.mkForce true;
        networkmanager.wifi.backend = "iwd";
        wireless.iwd.enable = true;
      };

      nix = {
        package = pkgs.nixVersions.latest;
        registry =
          (lib.mapAttrs (_: flake: { inherit flake; }) (
            lib.filterAttrs (name: value: lib.types.isType "flake" value && name != "self") inputs
          ))
          // {
            nixpkgs = lib.mkForce { flake = inputs.nixpkgs; };
          };

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
          extra-platforms = config.boot.binfmt.emulatedSystems;
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

        pam = {
          services.sddm.kwallet.enable = true;
          loginLimits = [
            {
              domain = "@realtime";
              type = "-";
              item = "rtprio";
              value = 98;
            }
            {
              domain = "@realtime";
              type = "-";
              item = "memlock";
              value = "unlimited";
            }
            {
              domain = "@realtime";
              type = "-";
              item = "nice";
              value = -11;
            }
          ];
        };

        rtkit.enable = true;
      };

      sops = {
        defaultSopsFile = null;
        age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      };

      services = {
        resolved = {
          enable = true;
        };

        openssh = {
          enable = true;
          startWhenNeeded = true;
          allowSFTP = true;
          settings.PermitRootLogin = "no";
          openFirewall = true;
        };

        xremap.enable = false;

        displayManager = {
          sddm = {
            enable = true;
            wayland.enable = true;
            settings.General.InputMethod = "";
          };

          autoLogin = {
            enable = false;
            user = "kid";
          };
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

        udev.extraRules = ''
          ACTION=="add|change", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"
          ACTION=="add|change", SUBSYSTEM=="usb", TEST=="power/wakeup", ATTR{power/wakeup}="disabled"
          SUBSYSTEM=="ata_port", KERNEL=="ata*", ATTR{device/power/control}="auto"
          KERNEL=="cpu_dma_latency", GROUP="realtime"
        '';

        btrfs.autoScrub = {
          enable = true;
          fileSystems = [ "/" ];
          interval = "weekly";
        };
      };

      # system = {
      #   stateVersion = lib.mkDefault "25.05";
      #   configurationRevision = self.shortRev or self.dirtyShortRev or "dirty";
      #   nixos.label = "${config.system.nixos.version}-nixfiles-${config.system.configurationRevision}";
      # };

      boot = {
        lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
        };

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
            enable = lib.mkForce false;
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
        xone.enable = true;
        uinput.enable = true;
        sensor.iio.enable = true;
        bluetooth.enable = true;
        enableRedistributableFirmware = true;
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

      powerManagement = {
        powertop.enable = true;
        scsiLinkPolicy = "med_power_with_dipm";
      };

      stylix = {
        enable = true;
        image = ../../../modules/base/theme/stylix/gruvbox-dark-rainbow.png;
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
