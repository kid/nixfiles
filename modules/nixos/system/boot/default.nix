{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixfiles.system.boot;
  inherit (lib.nixfiles) mkBoolOpt;
in
{
  options.nixfiles.system.boot = {
    enable = mkEnableOption "boot";
    plymouth = mkBoolOpt true "Whether to enable the Plymouth boot splash";
    silent = mkBoolOpt true "Whether to enable silent boot";
    rememberLast = mkBoolOpt false "Whether to remember the last selected boot";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      efibootmgr
      efitools
      efivar
    ];

    boot = {
      # 1: system is unusable | 3: error condition | 7: very verbose
      consoleLogLevel = 3;
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
          configurationLimit = 10;
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
        cleanOnBoot = mkDefault true;
        tmpfsSize = mkDefault "50%";
      };
    };
  };
}
