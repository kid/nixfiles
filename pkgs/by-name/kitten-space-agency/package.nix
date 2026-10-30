# Kitten Space Agency (RocketWerkz), official experimental Linux build.
# Official downloads need an Ahwoo login; fetched from the public
# ksa-archive.net mirror (same URL as AUR kittenspaceagency-bin).
{
  lib,
  stdenvNoCC,
  fetchurl,
  buildFHSEnv,
  makeDesktopItem,
  writeShellScript,
}:
let
  pname = "kitten-space-agency";
  # renovate: datasource=custom.kitten-space-agency depName=kitten-space-agency versioning=loose
  version = "2026.10.25.5707";
  build = lib.last (lib.splitString "." version);

  meta = {
    description = "Kitten Space Agency space flight simulator (experimental Linux build)";
    homepage = "https://ahwoo.com/app/100000/kitten-space-agency";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
      binaryBytecode
    ];
    platforms = [ "x86_64-linux" ];
  };

  game = stdenvNoCC.mkDerivation {
    pname = "${pname}-unwrapped";
    inherit version meta;

    src = fetchurl {
      url = "https://files.ksa-archive.net/builds/${build}/ksa_linux_v${version}.tar.gz";
      hash = "sha256-PLYFuRY1oHiHD3G8dt/sJgymg3M2mtABBvnvVdhY5UQ=";
    };

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;
    # Self-contained .NET apphost + prebuilt native libs; runs inside the FHS env, so no strip/patchelf needed.
    dontFixup = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/kitten-space-agency
      tar -xzf $src -C $out/share/kitten-space-agency
      chmod 755 $out/share/kitten-space-agency/KSA $out/share/kitten-space-agency/Brutal.Monitor.Subprocess
      runHook postInstall
    '';
  };

  icon = fetchurl {
    url = "https://aur.archlinux.org/cgit/aur.git/plain/kittenspaceagency.png?h=kittenspaceagency-bin&id=f82072a5527b66f4b501e62b34e6ca8911764100";
    sha256 = "4e10dedc70614419a5a2354642556d15fe331565d0d94a4fa41ab04dd8b24486";
  };

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "Kitten Space Agency";
    comment = meta.description;
    exec = pname;
    icon = pname;
    categories = [ "Game" ];
  };
in
buildFHSEnv {
  inherit pname version meta;

  # refresh-nix-hash (nix-update) finds the tarball through `src`.
  passthru.src = game.src;

  targetPkgs =
    pkgs: with pkgs; [
      stdenv.cc.cc.lib
      zlib
      icu
      openssl
      krb5
      vulkan-loader
      libx11
      libxcursor
      libxrandr
      libxi
      libxinerama
      libxext
      libxrender
      libxcb
      libxkbcommon
      wayland
      libdecor
      alsa-lib
      libpulseaudio
    ];

  runScript = writeShellScript "${pname}-launch" ''
    mkdir -p "$HOME/Documents"
    cd ${game}/share/kitten-space-agency
    # Native Wayland (early support since 5638); detached windows are disabled there.
    exec ./KSA -wayland "$@"
  '';

  extraInstallCommands = ''
    install -Dm644 ${icon} $out/share/icons/hicolor/256x256/apps/${pname}.png
    install -Dm644 ${desktopItem}/share/applications/${pname}.desktop -t $out/share/applications
  '';
}
