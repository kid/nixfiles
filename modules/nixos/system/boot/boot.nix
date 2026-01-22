{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkForce
    mkIf
    ;

  cfg = config.nixfiles.system.boot;
in
{
  config = mkIf cfg.enable {
    nixfiles.packages = {
      inherit (pkgs)
        efibootmgr
        efitools
        efivar
        ;
    };

    boot = {
      # 1: system is unusable | 3: error condition | 7: very verbose
      consoleLogLevel = 3;

      # FIXME: should not be using force here
      kernelPackages = mkForce cfg.kernel;

      kernelParams =
        lib.optionals cfg.plymouth [
          "quiet"
          "splash"

          # disable the cursor in vt to get a black screen during intermissions
          "vt.global_cursor_default=0"

          # "console=tty1"
        ]
        ++ lib.optionals cfg.silent [
          # tell kernel to not be verbose
          "quiet"

          # kernel log message level
          # "loglevel=3" # 1: system is unusable | 3: error condition | 7: very verbose

          # udev log message level
          "udev.log_level=3"

          # lower the udev log level to show only errors or worse
          "rd.udev.log_level=3"

          # disable systemd status messages
          "systemd.show_status=auto"

          # rd prefix means systemd-udev will be used instead of initrd
          "rd.systemd.show_status=auto"

          "fbcon=nodefer"
        ];

      initrd = {
        systemd.enable = true;
        verbose = cfg.plymouth || cfg.silent;
      };

      loader = {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };

        systemd-boot = {
          enable = true;
          configurationLimit = 3;
          consoleMode = "max";

          extraInstallCommands = lib.mkIf cfg.rememberLast ''
            ${pkgs.gnused}/bin/sed -E -i 's/default nixos-generation-[0-9]+\.conf/default @saved/g' /boot/loader/loader.conf
          '';
        };
      };

      plymouth = {
        enable = cfg.plymouth;
      };

      tmp = {
        # FIXME: not enough to build kernels...
        useTmpfs = mkDefault false;
        cleanOnBoot = mkDefault (!config.boot.tmp.useTmpfs);
        tmpfsSize = mkDefault "50%";
      };
    };
  };
}
