{
  inputs = {
    flake-utils.url = github:numtide/flake-utils;
    taffybar.url = github:taffybar/taffybar;
  };
  outputs = { self, flake-utils, nixpkgs, taffybar }:
    let
      overlay = final: prev: {
        haskellPackages = prev.haskellPackages.override (old: {
          overrides = prev.lib.composeExtensions (old.overrides or (_: _: { }))
            (hself: hsuper: {
              taffybar-kid =
                hself.callCabal2nix "taffybar-kid"
                  (nixpkgs.lib.sourceByRegex ./.
                    [
                      "taffybar.hs"
                      "taffybar-kid.cabal"
                    ])
                  { };
            });
        });
      };
      overlays = taffybar.overlays ++ [ overlay ];
    in
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = import nixpkgs { inherit system overlays; };
        in
        rec {
          devShell = pkgs.haskellPackages.shellFor {
            packages = p: [ p.taffybar-kid ];
            nativeBuildInputs = [
              pkgs.cabal-install
              pkgs.haskell-language-server
            ];
          };
          defaultPackage = pkgs.haskellPackages.taffybar-kid;
          # defaultPackage = pkgs.haskellPackages.taffybar-kid.overrideAttrs (old: rec {
          #   nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.makeWrapper ];
          #   installPhase = old.installPhase + ''
          #     ln -s ${pkgs.haskellPackages.taffybar-kid}/bin/taffybar-kid $out/bin/taffybar-${system}
          #   '';
          #   # postFixup = ''
          #   #   wrapProgram $out/bin/taffybar-${system} --prefix PATH : ${pkgs.lib.makeBinPath [pkgs.haskellPackages.xmobar]}
          #   # '';
          # });
        }) // { inherit overlay overlays; };
}
