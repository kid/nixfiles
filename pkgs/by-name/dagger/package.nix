{
  lib,
  stdenvNoCC,
  fetchurl,
  installShellFiles,
  python3,
}:
let
  # renovate: datasource=github-tags depName=dagger/dagger versioning=semver
  version = "1.0.0-beta.21";
  sources = {
    x86_64-linux = {
      platform = "linux_amd64";
      hash = "sha256-xax3elyZCJhpZglDOBE24iF3tZpGQS4xDC/vWUdgoEE=";
    };
    aarch64-linux = {
      platform = "linux_arm64";
      hash = "sha256-up1VY4Y2kYo0BDE1EbzrpcwK8i9IfBwbalumDOcKYbs=";
    };
    armv7l-linux = {
      platform = "linux_armv7";
      hash = "sha256-HguWv84BYq2R9o4KFBubBKUb+7DkNrMMdjyg/Q27yXM=";
    };
    x86_64-darwin = {
      platform = "darwin_amd64";
      hash = "sha256-/b4ZHJZdJA7pzJBxn6ncoVhoBcu4mwoAhzFKhKCTc1Q=";
    };
    aarch64-darwin = {
      platform = "darwin_arm64";
      hash = "sha256-eB9IYsAioZuaTEmLWeHZz9oe483IziEORUW9iEKnQW0=";
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
