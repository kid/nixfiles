{
  services.openssh = {
    enable = true;

    startWhenNeeded = true;
    allowSFTP = true;

    settings = {
      PermitRootLogin = "no";
    };

    openFirewall = true;
  };
}
