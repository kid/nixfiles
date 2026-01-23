{ inputs, ... }:
{
  nixpkgs.overlays = with inputs; [
    nur.overlays.default
  ];
}
