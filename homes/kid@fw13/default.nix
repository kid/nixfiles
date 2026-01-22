{ self, pkgs, ... }:
{
  imports = [
    "${self}/legacy/modules/home-manager"
    "${self}/legacy/modules/home-manager/desktop.nix"
    "${self}/legacy/modules/home-manager/plasma.nix"
  ];

  nixfiles = {
    packages = {
      inherit (pkgs) opencode;
    };

    services.xremap.enable = true;

    programs.gui.enable = true;
  };

  programs.plasma.input.touchpads = [
    {
      vendorId = "093A";
      productId = "0274";
      name = "PIXA3854:00 093A:0274 Touchpad";
      naturalScroll = true;
      tapToClick = false;
      rightClickMethod = "twoFingers";
      middleButtonEmulation = true;
    }
  ];
}
