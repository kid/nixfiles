{ config, ... }:
{
  system.nixos.label = "${config.system.nixos.version}-nixfiles-${config.system.configurationRevision}";
}
