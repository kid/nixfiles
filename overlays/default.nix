{ inputs, ... }:
{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable { system = final.system; };
  };

  # leftwm = prev.leftwm.overrideAttrs (old: rec {
  #   version = "48936034967d36cad600df28ce0907cf602503d1";
  #
  #   src = prev.fetchFromGitHub {
  #     owner = "leftwm";
  #     repo = "leftwm";
  #     rev = version;
  #     sha256 = "sha256-AHSPNx5g/D6H1cu2FVJ6BKxEydmCD5/S2IiSvynIYaI=";
  #   };
  #
  #   cargoDeps = old.cargoDeps.overrideAttrs (_: {
  #     inherit src;
  #     rev = version;
  #     outputHash = "sha256-3RAuh/XOKkfiBowMZupNcfJOd+MHrzFBGJ+m9Q+fqFw=";
  #   });
  #
  #   buildFeatures = [ "journald" ];
  #
  #   buildInputs = old.buildInputs ++ [ prev.systemd ];
  #   postInstall = old.postInstall + ''
  #     for p in $out/bin/leftwm*; do
  #       patchelf --set-rpath "${prev.lib.makeLibraryPath [(prev.lib.getLib prev.systemd)]}" $p
  #     done
  #   '';
  #   nativeBuildInputs = old.nativeBuildInputs ++ [ prev.pkg-config ];
  # });
}
