{
  lib,
  stdenvNoCC,
  fetchurl,
  installShellFiles,
  python3,
}:
let
  # renovate: datasource=github-tags depName=dagger/dagger versioning=semver
  version = "1.0.0-beta.27";
  sources = {
    x86_64-linux = {
      platform = "linux_amd64";
      hash = "sha256-3io8pWnDqVXVzpjSxIebZ6RFnDlKfhaEJhunFSvbaGU=";
    };
    aarch64-linux = {
      platform = "linux_arm64";
      hash = "sha256-HvADpFItTznIYtbdNgvCkWpgX4eq09zkmIwB9LzXM1g=";
    };
    armv7l-linux = {
      platform = "linux_armv7";
      hash = "sha256-iP/8isA+NrgAtpiW5BrcAp6Ng1JyUtXAgPut8fFLH7Y=";
    };
    x86_64-darwin = {
      platform = "darwin_amd64";
      hash = "sha256-FLY9ZlwL1xoogrfpDkDc+WrKJ+vuaWTTDIgCz1Cbwp0=";
    };
    aarch64-darwin = {
      platform = "darwin_arm64";
      hash = "sha256-Xv1/XOw5CT3RDUA1qujuh/gkA2BsCm2VjXSg7e4EFxo=";
    };
  };
  source = sources.${stdenvNoCC.hostPlatform.system};
in
stdenvNoCC.mkDerivation {
  pname = "dagger";
  inherit version;

  src = fetchurl {
    url = "https://dl.dagger.io/dagger/releases/${version}/dagger_v${version}_${source.platform}.tar.gz";
    inherit (source) hash;
  };

  sourceRoot = ".";
  dontBuild = true;
  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall
    install -Dm755 dagger $out/bin/dagger
    installShellCompletion --cmd dagger \
      --bash <($out/bin/dagger completion bash) \
      --fish <($out/bin/dagger completion fish) \
      --zsh <($out/bin/dagger completion zsh)
    runHook postInstall
  '';

  passthru.updateScript = [
    (lib.getExe python3)
    ./update.py
  ];

  meta = {
    description = "Composable workflows with software components in containers (v1 beta)";
    homepage = "https://dagger.io";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = builtins.attrNames sources;
    mainProgram = "dagger";
  };
}
