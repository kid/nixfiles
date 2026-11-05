{
  # KWallet as the Secret Service provider, unlocked from the login password.
  # Plasma's module sets the same up; this keeps it working in sessions without Plasma.
  # Each session still has to run kwallet-pam's pam_kwallet_init to hand the key over.
  nf.desktop.kwallet = {
    nixos =
      { lib, pkgs, ... }:
      {
        environment.systemPackages = with pkgs.kdePackages; [
          kwallet
          kwallet-pam
          kwalletmanager
        ];

        security.pam.services.login.kwallet = {
          enable = true;
          # mkDefault: Plasma's module sets the same package and a package option can't be defined twice.
          package = lib.mkDefault pkgs.kdePackages.kwallet-pam;
        };
      };
  };
}
