{ pkgs, ... }: {
  services.printing = {
    enable = true;
    drivers = with pkgs; [ brlaser ];
    clientConf = ''
      AllowAnyRoot Yes
      AllowExpiredCerts No
      Encryption IfRequested
      SSLOptions None
      TrustOnFirstUse Yes
      ValidateCerts No
      ServerName 10.0.10.20
    '';
  };
}
