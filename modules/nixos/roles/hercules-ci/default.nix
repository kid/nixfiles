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
      # concurrentTasks = 4;
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

  # TODO: move this somewhere else
  services.earlyoom = {
    enable = true;
    # enableNotifications = true;
    extraArgs =
      let
        catPatterns = patterns: builtins.concatStringsSep "|" patterns;
        preferPatterns = [
          "hercules-ci-age"
        ];
        avoidPatterns = [
          "bash"
          "sshd"
          "systemd"
          "systemd-logind"
          "systemd-udevd"
          "systemd-networkd"
        ];
      in
      [
        "--prefer"
        "'^(${catPatterns preferPatterns})$'"
        "--avoid"
        "'^(${catPatterns avoidPatterns})$'"
      ];
  };
})
