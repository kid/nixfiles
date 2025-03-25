{ config, ... }:
{
  hardware.uinput.enable = true;
  # TODO: should add user to group directly isntead?
  users.groups.uinput.members = [ config.nixfiles.user.name ];
  users.groups.input.members = [ config.nixfiles.user.name ];
}
