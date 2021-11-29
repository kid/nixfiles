{
  inputs = {
    flake-utils.url = github:numtide/flake-utils;
  };
  outputs = { self, flake-utils, nixpkgs }:
    let
      overlay = final: prev: {
        haskellPackages = prev.haskellPackages.override (old: {
          overrides = prev.lib.composeExtensions (old.overrides or (_: _: { }))
            (hself: hsuper: {
              xmobar-kid =
                hself.callCabal2nix "xmobar-kid"
                  (nixpkgs.lib.sourceByRegex ./.
                    [
                      "xmobar.hs"
                      "xmobar-kid.cabal"
                    ])
                  { };
            });
        });
      };
      overlays = [ overlay ];
    in
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = import nixpkgs { inherit system overlays; };
        in
        rec {
          devShell = pkgs.haskellPackages.shellFor {
            packages = p: [ p.xmobar-kid ];
            nativeBuildInputs = [
              pkgs.cabal-install
              pkgs.haskell-language-server
            ];
          };
          defaultPackage = pkgs.haskellPackages.xmobar-kid;
          # defaultPackage = pkgs.haskellPackages.xmobar-kid.overrideAttrs (old: rec {
          #   nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.makeWrapper ];
          #   installPhase = old.installPhase + ''
          #     ln -s ${pkgs.haskellPackages.xmobar-kid}/bin/xmobar-kid $out/bin/xmobar-${system}
          #   '';
          #   # postFixup = ''
          #   #   wrapProgram $out/bin/xmobar-${system} --prefix PATH : ${pkgs.lib.makeBinPath [pkgs.haskellPackages.xmobar]}
          #   # '';
          # });
        }) // { inherit overlay overlays; };
}
