{
  # Client side SSH configuration
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks."*" = {
      compression = true;
      forwardAgent = true;
    };
  };
}
