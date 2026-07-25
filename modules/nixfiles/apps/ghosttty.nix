{
  nf.apps.ghostty = {
    homeManager = {
      programs.ghostty = {
        enable = true;
        settings.keybind = [
          "ctrl+shift+h=goto_split:left"
          "ctrl+shift+j=goto_split:bottom"
          "ctrl+shift+k=goto_split:top"
          "ctrl+shift+l=goto_split:right"
        ];
      };
    };
  };
}
