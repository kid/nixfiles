{
  imports = [ ../common.nix ];

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
