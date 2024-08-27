{
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;

    storageDriver = "overlay2";

    enableOnBoot = false;
  };
}
