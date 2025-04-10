{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.nixfiles.services.printing;
in
{

  options.nixfiles.services.printing.enable = mkEnableOption "printing";

  config = mkIf cfg.enable {
    services = {
      printing = {
        enable = true;

        drivers = builtins.attrValues {
          inherit (pkgs) brlaser;
        };
      };

      # required for network discovery of printers
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };

    hardware.printers =
      let
        name = "Brother_HL-2030_series";
      in
      {
        ensureDefaultPrinter = name;
        ensurePrinters = [
          {
            inherit name;
            deviceUri = "http://10.0.100.137:631/printers/${name}";
            model = "drv:///brlaser.drv/brl2320d.ppd";
            ppdOptions = {
              PageSize = "A4";
            };
          }
        ];
      };
  };
}
