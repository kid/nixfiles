{
  nf.dev.docker = {
    # TODO: add user to docker group

    nixos = {
      virtualisation.docker.enable = true;
    };

    darwin =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          docker
          colima
        ];
      };
  };
}
