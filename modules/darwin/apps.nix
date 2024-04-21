{ pkgs, ... }:
{
  homebrew = {
    taps = [ "jakehilborn/jakehilborn" ];
    brews = [
      "displayplacer"
      "webp"
    ];
    casks = [
      "1password-beta"
      "scroll-reverser"
      "spotify"
      "pgAdmin4"
    ];
  };

  hm.home.packages = with pkgs; [
    colima
    docker
    postgresql
  ];
}
