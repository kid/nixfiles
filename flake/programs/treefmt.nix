{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem =
    { config, ... }:
    {
      formatter = config.treefmt.build.wrapper;

      treefmt = {
        programs = {
          deadnix.enable = true;
          statix.enable = true;
          nixfmt.enable = true;
          prettier.enable = true;
          prettier.settings.editorconfig = true;
          just.enable = true;
          shellcheck.enable = true;
          shfmt.enable = true;
          # Force use of editorconfig
          shfmt.indent_size = null;
        };

        settings = {
          global.excludes = [
            "LICENSE"
            # unsupported extensions
            "*.{gif,png,svg,tape,mts,lock,mod,sum,toml,env,envrc,org,yuck,gitignore,editorconfig}"
            # sops files
            "*.sops.{json,yaml}"
            # ignore vendor dependencies
            "vendor/*"
          ];

          formatter = {
            deadnix.priority = 1;
            statix.priority = 2;
            nixfmt.priority = 3;
          };
        };
      };
    };
}
