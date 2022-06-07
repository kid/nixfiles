{
  homebrew = {
    enable = true;
    autoUpdate = false;
    brewPrefix = "/opt/homebrew/bin";
    global = {
      brewfile = true;
      noLock = true;
    };
    taps = [
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/core"
      "homebrew/services"
    ];
  };
}
