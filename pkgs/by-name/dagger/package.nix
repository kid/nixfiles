{
  lib,
  stdenvNoCC,
  fetchurl,
  installShellFiles,
  python3,
}:
let
  # renovate: datasource=github-tags depName=dagger/dagger versioning=semver
  version = "1.0.0-beta.29";
  sources = {
    x86_64-linux = {
      platform = "linux_amd64";
      hash = "sha256-LpBubhKxX5KNhkl/Ho9/4MRhYTzg9trdhq/V6invxbI=";
    };
    aarch64-linux = {
      platform = "linux_arm64";
      hash = "sha256-Bx+HHKEF9wskRSQoTwq8eU2QpNnRoy3UqfwXwZUYQ7s=";
    };
    armv7l-linux = {
      platform = "linux_armv7";
      hash = "sha256-NoX8GWcJ1d8G8pqjwCxnYFnWesSgs3OTU+g+I5cObrk=";
    };
    x86_64-darwin = {
      platform = "darwin_amd64";
      hash = "sha256-aCYmVqeo8R2dF4Nt92PjZPEc71gBn27SPVdUcRlM1KA=";
    };
    aarch64-darwin = {
      platform = "darwin_arm64";
      hash = "sha256-P9JlZyIGiQ/DlLa2OlYKMsuVNCOvIX5KpyM8DSsCfHE=";
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
