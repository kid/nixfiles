{ inputs, ... }:
{
  nixpkgs.overlays = with inputs; [
    nur.overlays.default
    niri.overlays.niri
  ];
}
