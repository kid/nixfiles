# Minimal config for servers
{
  imports = [
    ../user/modules/shell.nix
    ../user/modules/editor.nix
  ];

  # Client side SSH configuration
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "10m";
  };
}
