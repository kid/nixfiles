{
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mapAttrs
    types
    ;
  inherit (lib.attrsets) getAttrFromPath setAttrByPath;
in
rec {
  mkOpt =
    type: default: description:
    mkOption { inherit type default description; };

  # mkOpt' = type: default: mkOpt type default null;

  mkBoolOpt = mkOpt types.bool;
  # mkBoolOpt' = mkOpt' types.bool;

  enabled = {
    enable = true;
  };

  disabled = {
    enable = false;
  };

  # Apply mkDefault to all attributes of a set
  default-attrs = mapAttrs (_key: lib.mkDefault);

  # Helper to create a module with an enable option
  mkModule =
    path: enabled: config: extraOptions: extraConfig:
    let
      # relPath = [
      #   namespace
      # ] ++ lib.tail (lib.path.subpath.components (lib.path.removePrefix ../../modules path));
      relPath = [
        "nixfiles"
      ]
      ++ (lib.pipe path [
        (lib.path.removePrefix ../../modules)
        lib.path.subpath.components
        lib.tail
      ]);
      # |> lib.path.removePrefix ../../modules
      # |> lib.path.subpath.components
      # |> lib.tail; # Remove the first element, which is the module type (home / nixos / darwin)
      name = lib.strings.concatStringsSep "." relPath;
      cfg = (getAttrFromPath relPath) config;
    in
    {
      options = setAttrByPath relPath (
        {
          enable = mkBoolOpt enabled "Whether to enable the ${name} module";
        }
        // extraOptions
      );

      config = mkIf cfg.enable (extraConfig cfg);
    };
}
