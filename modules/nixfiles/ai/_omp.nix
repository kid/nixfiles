{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    ;

  cfg = config.programs.omp;

  jsonFormat = pkgs.formats.json { };
  yamlFormat = pkgs.formats.yaml { };

  configDir = ".omp/agent";

  # omp rewrites config.yml at runtime, so nix-managed settings go into a
  # read-only overlay instead (overlays take precedence over config.yml).
  settingsFile = yamlFormat.generate "omp-config.yml" cfg.settings;

  wrappedPackage =
    if cfg.settings != { } then
      pkgs.symlinkJoin {
        inherit (cfg.package) meta;
        name = "${lib.getName cfg.package}-wrapped-${lib.getVersion cfg.package}";
        paths = [ cfg.package ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/omp --prefix PI_CONFIG_FILES : ${settingsFile}
        '';
      }
    else
      cfg.package;

  mcpServers = lib.mapAttrs (
    name: server:
    lib.hm.mcp.transformMcpServer {
      inherit server;
      extraTransforms = [
        lib.hm.mcp.addType
        (lib.hm.mcp.wrapEnvFilesCommand { inherit pkgs name; })
      ];
    }
  ) config.programs.mcp.servers;
in
{
  options.programs.omp = {
    enable = mkEnableOption "omp (oh-my-pi) coding agent";

    package = mkPackageOption pkgs [ "llm-agents" "omp" ] { };

    enableMcpIntegration = mkEnableOption "" // {
      description = ''
        Whether to write {option}`programs.mcp.servers` to
        {file}`~/.omp/agent/mcp.json`.
      '';
    };

    settings = mkOption {
      inherit (yamlFormat) type;
      default = { };
      example = {
        theme.dark = "titanium";
        modelRoles.default = "anthropic/claude-sonnet-4-5:high";
      };
      description = ''
        Settings passed to omp as a {env}`PI_CONFIG_FILES` overlay.
        {file}`~/.omp/agent/config.yml` stays writable for omp.
      '';
    };

    models = mkOption {
      inherit (yamlFormat) type;
      default = { };
      example = {
        providers.ollama = {
          baseUrl = "http://localhost:11434/v1";
          api = "openai-completions";
          models = [ { id = "llama3.1:8b"; } ];
        };
      };
      description = ''
        Custom models and providers written to {file}`~/.omp/agent/models.yml`.
      '';
    };

    lspServers = mkOption {
      type = lib.types.attrsOf jsonFormat.type;
      default = { };
      example = literalExpression ''
        {
          nixd.command = lib.getExe pkgs.nixd;
        }
      '';
      description = ''
        LSP servers written to {file}`~/.omp/agent/lsp.json`. Each entry is
        merged field by field over the omp built-in server of the same name.
      '';
    };

    context = mkOption {
      type = lib.types.either lib.types.lines lib.types.path;
      default = "";
      description = ''
        Global context written to {file}`~/.omp/agent/AGENTS.md`.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ wrappedPackage ];

    home.file = lib.mkMerge [
      (mkIf (cfg.models != { }) {
        "${configDir}/models.yml".source = yamlFormat.generate "omp-models.yml" cfg.models;
      })

      (mkIf (cfg.lspServers != { }) {
        "${configDir}/lsp.json".source = jsonFormat.generate "omp-lsp.json" {
          servers = cfg.lspServers;
        };
      })

      (mkIf (cfg.enableMcpIntegration && config.programs.mcp.enable && mcpServers != { }) {
        "${configDir}/mcp.json".source = jsonFormat.generate "omp-mcp.json" { inherit mcpServers; };
      })

      (
        if lib.hm.strings.isPathLike cfg.context then
          { "${configDir}/AGENTS.md".source = cfg.context; }
        else
          mkIf (cfg.context != "") {
            "${configDir}/AGENTS.md".text = cfg.context;
          }
      )
    ];
  };
}
