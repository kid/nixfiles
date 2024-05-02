{ config, ... }:
{
  hardware.uinput.enable = true;
  users.groups.uinput.members = [ config.user.name ];
  users.groups.input.members = [ config.user.name ];
}
