{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    font-awesome
  ];

  # console = {
  #   earlySetup = true;
  # };
}
