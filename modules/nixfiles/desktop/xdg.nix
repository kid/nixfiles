{
  nf.desktop = {
    homeManager =
      { config, pkgs, ... }:
      {
        xdg = {
          enable = true;
          mimeApps = {
            enable = true;
            associations.added = {
              "application/json" = [ "nvim.desktop" ];
              "text/english" = [ "nvim.desktop" ];
              "text/plain" = [ "nvim.desktop" ];
              "text/x-makefile" = [ "nvim.desktop" ];
              "text/x-c++hdr" = [ "nvim.desktop" ];
              "text/x-c++src" = [ "nvim.desktop" ];
              "text/x-chdr" = [ "nvim.desktop" ];
              "text/x-csrc" = [ "nvim.desktop" ];
              "text/x-java" = [ "nvim.desktop" ];
              "text/x-moc" = [ "nvim.desktop" ];
              "text/x-pascal" = [ "nvim.desktop" ];
              "text/x-tcl" = [ "nvim.desktop" ];
              "text/x-tex" = [ "nvim.desktop" ];
              "application/x-shellscript" = [ "nvim.desktop" ];
              "text/x-c" = [ "nvim.desktop" ];
              "text/x-c++" = [ "nvim.desktop" ];
              "video/*" = [ "mpv.desktop" ];
              "audio/*" = [ "mpv.desktop" ];
              "text/html" = [ "firefox.desktop" ];
              "x-scheme-handler/http" = [ "firefox.desktop" ];
              "x-scheme-handler/https" = [ "firefox.desktop" ];
              "x-scheme-handler/ftp" = [ "firefox.desktop" ];
              "x-scheme-handler/about" = [ "firefox.desktop" ];
              "x-scheme-handler/unknown" = [ "firefox.desktop" ];
              "x-scheme-handler/discord" = [ "Discord.desktop" ];
            };
            defaultApplications = config.xdg.mimeApps.associations.added;
          };
          autostart = {
            enable = true;
            entries = [
              "${pkgs._1password-gui}/share/applications/1password.desktop"
              "${pkgs.telegram-desktop}/share/applications/org.telegram.desktop.desktop"
            ];
          };
        };

      };
  };
}
