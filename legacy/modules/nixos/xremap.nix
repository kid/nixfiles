{ config, namespace, ... }:
{
  hardware.uinput.enable = true;
  # TODO: should add user to group directly isntead?
  users.groups.uinput.members = [ config.${namespace}.user.name ];
  users.groups.input.members = [ config.${namespace}.user.name ];
}
