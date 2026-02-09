{ config, ... }:
{
  nixos.label = "${config.system.nixos.version}-nixfiles-${config.system.configurationRevision}";
}
