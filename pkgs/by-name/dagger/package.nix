{
  lib,
  stdenvNoCC,
  fetchurl,
  installShellFiles,
  python3,
}:
let
  # renovate: datasource=github-tags depName=dagger/dagger versioning=semver
  version = "1.0.0-beta.24";
  sources = {
    x86_64-linux = {
      platform = "linux_amd64";
      hash = "sha256-ZIpf/PfW1yRSbSCUIGb9AjzfK4KEIE0Mo+H89vB5P24=";
    };
    aarch64-linux = {
      platform = "linux_arm64";
      hash = "sha256-xv0dn6U6xIgKITc0EakjcgzWXmt6BaYXN5J4pSTuB40=";
    };
    armv7l-linux = {
      platform = "linux_armv7";
      hash = "sha256-Rq4+oXbPaAIwyA4iUhIGoBC1yCn853i3ivyZK1Wa8Xc=";
    };
    x86_64-darwin = {
      platform = "darwin_amd64";
      hash = "sha256-Frh5oIO4ugvo24DVhwHicmZFrbzdkIgEF5kYE8UTMQI=";
    };
    aarch64-darwin = {
      platform = "darwin_arm64";
      hash = "sha256-8LW/4DL40kVjPuA8NQ/MStcIm/RqH4bbCo3d8wEcpfw=";
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
