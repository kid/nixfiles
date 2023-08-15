{
  # Client side SSH configuration
  programs.ssh = {
    enable = true;
    compression = true;
    # controlMaster = "auto";
    # controlPersist = "10m";
    forwardAgent = true;
  };
}
