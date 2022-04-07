{
  # Client side SSH configuration
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "10m";
  };
}
