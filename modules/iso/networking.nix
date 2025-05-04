{
  networking = {
    useNetworkd = true;
    wireless.enable = true;
  };

  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBx9vvChkupOOoETU4Y1hv+469DFV0TdEVdONeqfXn04 kid@nixos"
  ];
}
