{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) mkModule;
in
mkModule ./. false config { } (_cfg: {
  services.hercules-ci-agent = {
    enable = true;
    settings = {
      clusterJoinTokenPath = config.sops.secrets."hercules_ci/token".path;
      binaryCachesPath = config.sops.secrets."hercules_ci/caches".path;
    };
  };
  sops = {
    defaultSopsFormat = "yaml";
    secrets = {
      "hercules_ci/token" = {
        owner = config.systemd.services.hercules-ci-agent.serviceConfig.User;
      };
      "hercules_ci/caches" = {
        owner = config.systemd.services.hercules-ci-agent.serviceConfig.User;
      };
    };
  };
})
