{
  lib,
  stdenvNoCC,
  fetchurl,
  installShellFiles,
  python3,
}:
let
  # renovate: datasource=github-tags depName=dagger/dagger versioning=semver
  version = "1.0.0-beta.28";
  sources = {
    x86_64-linux = {
      platform = "linux_amd64";
      hash = "sha256-q9n36V8DxRfjPPurCRf6FZPXPgiNaTBCWYhPikfMYaE=";
    };
    aarch64-linux = {
      platform = "linux_arm64";
      hash = "sha256-5prR9faAJM84CYvOkC3s+zMIWAnu8502ZG3H1atr+ss=";
    };
    armv7l-linux = {
      platform = "linux_armv7";
      hash = "sha256-l38b3dME4QgQor9Wo/RJZkBx22y4xUDPQNHWdPUrtW0=";
    };
    x86_64-darwin = {
      platform = "darwin_amd64";
      hash = "sha256-8vqdl0Ghtbd2f2SqncJFWmdrDMYuR6cyTqigcS9SUu0=";
    };
    aarch64-darwin = {
      platform = "darwin_arm64";
      hash = "sha256-wSy8KTQ5N1+9/cYxjzzwoFjNV7c+6tjXe/4wdbs1I5k=";
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
