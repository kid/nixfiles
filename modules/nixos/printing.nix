{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    drivers = with pkgs; [ brlaser ];
  };
  hardware.printers = {
    ensurePrinters = [
      {
        name = "Brother_HL-2030_series";
        deviceUri = "http://10.0.100.137:631/printers/Brother_HL-2030_series";
        model = "drv:///brlaser.drv/brl2320d.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
    ];
    ensureDefaultPrinter = "Brother_HL-2030_series";
  };
}
