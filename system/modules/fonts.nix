{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  # console = {
  #   earlySetup = true;
  # };
}
