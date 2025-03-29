{ config, ... }:
{
  hardware.uinput.enable = true;
  # TODO: should add user to group directly isntead?
  users.groups.uinput.members = [ config.nixfiles.system.mainUser ];
  users.groups.input.members = [ config.nixfiles.system.mainUser ];
}
