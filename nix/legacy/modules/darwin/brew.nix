{
  homebrew = {
    enable = true;
    brewPrefix = "/opt/homebrew/bin";
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
    global = {
      brewfile = true;
      autoUpdate = true;
    };
    taps = [
      "homebrew/bundle"
      # "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      # "homebrew/core"
      "homebrew/services"
    ];
  };
}
