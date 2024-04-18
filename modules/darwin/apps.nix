{ pkgs, ... }: {
  homebrew = {
    taps = [ "jakehilborn/jakehilborn" ];
    brews = [ "displayplacer" "webp" ];
    casks = [ "1password-beta" "scroll-reverser" "spotify" ];
  };

  hm.home.packages = with pkgs; [ colima docker ];
}
