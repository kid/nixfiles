{
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;

    storageDriver = "zfs";

    enableOnBoot = false;
  };
}
