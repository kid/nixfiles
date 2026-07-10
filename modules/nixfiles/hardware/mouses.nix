{
  nf.hardware.logitech = {
    nixos = { pkgs, ... }: {
      services.ratbagd.enable = true;

      environment.systemPackages = with pkgs; [
        piper
      ];
    };
  };

  nf.hardware.razer = {
    nixos = { ... }: {
      hardware.openrazer.enable = true;
      hardware.openrazer.users = [ "kid" ];
    };
  };
}
