# Minimal config for servers
{
  imports = [
    ./shell.nix
    ./editor.nix
  ];

  xdg.enable = true;

  # Client side SSH configuration
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "10m";
  };
}
