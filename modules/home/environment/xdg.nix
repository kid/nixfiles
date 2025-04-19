{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (pkgs.stdenv) isLinux;
  inherit (config.nixfiles.programs) defaults;

  browser = [
    "text/html"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/ftp"
    "x-scheme-handler/about"
    "x-scheme-handler/unknown"
  ];

  code = [
    "application/json"
    "text/english"
    "text/plain"
    "text/x-makefile"
    "text/x-c++hdr"
    "text/x-c++src"
    "text/x-chdr"
    "text/x-csrc"
    "text/x-java"
    "text/x-moc"
    "text/x-pascal"
    "text/x-tcl"
    "text/x-tex"
    "application/x-shellscript"
    "text/x-c"
    "text/x-c++"
  ];

  media = [
    "video/*"
    "audio/*"
  ];

  # images = [ "image/*" ];

  associations =
    (lib.genAttrs code (_: [ "nvim.desktop" ]))
    // (lib.genAttrs media (_: [ "mpv.desktop" ]))
    # // (lib.genAttrs images (_: [ "mpv.desktop" ]))
    // (lib.genAttrs media (_: [ "mpv.desktop" ]))
    // (lib.genAttrs browser (_: [ "${defaults.browser}.desktop" ]))
    // {
      "x-scheme-handler/discord" = [ "Discord.desktop" ];
    };
in
{
  xdg = {
    enable = true;

    mimeApps = {
      enable = isLinux;
      associations.added = associations;
      defaultApplications = associations;
    };
  };
}
