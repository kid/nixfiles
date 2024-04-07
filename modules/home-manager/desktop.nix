{ pkgs, inputs, ... }: {
  xdg.configFile."xmobar/gruvbox-dark.xmobarrc".source =
    ./files/gruvbox-dark.xmobarrc;
  xresources.extraConfig = builtins.readFile ./files/gruvbox-dark.xresources;

  gtk = {
    enable = true;

    # gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    # font = {
    #   name = "Roboto";
    #   package = pkgs.roboto;
    # };

    # theme = {
    #   name = "Gruvbox-Dark-BL";
    #   package = pkgs.gruvbox-gtk-theme;
    # };
  };

  # dconf.settings = {
  #   "org/gnome/desktop/interface" = {
  #     color-scheme = "prefer-dark";
  #   };
  # };

  home.packages = with pkgs; [
    xclip
    kitty
    rofi
    # (google-chrome-beta.override {
    #   commandLineArgs = [
    #     "--enable-features=WebUIDarkMode"
    #     "--force-dark-mode"
    #   ];
    # })
    chromium
    # _1password-gui
    discord
    # discord-canary
    webcord
    vesktop
    tdesktop # telegram
    polybar
    xorg.xmessage
    feh
    leftwm
    nfs-utils
    pmount
    pulsemixer
    portfolio
    freecad
    prusa-slicer
    alacritty
    # wlr-randr
    glxinfo
    deltachat-desktop
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = let browser = "firefox.desktop";
    in {
      "text/html" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/about" = browser;
      "x-scheme-handler/unknown" = browser;
    };
  };

  programs.firefox = {
    enable = true;
    profiles.kid = {
      # extensions = with inputs.firefox-addons.packages.x86_64-linux; [
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        sponsorblock
        ublock-origin
        improved-tube
        onepassword-password-manager
      ];
      search.force = true;
      search.engines = {
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              {
                name = "type";
                value = "packages";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }];

          icon =
            "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };
      };

      settings = { "browser.sessionstore.restore_on_demand" = false; };
    };
  };

  programs.rofi = {
    enable = true;
    extraConfig = { modi = "drun,window,ssh"; };

    # font = "FiraCode Nerd Font 11";
    # theme = "gruvbox-dark";
    terminal = "kitty";
  };

  # TODO put this somewhere else
  programs.kitty = {
    enable = true;
    font = {
      # name = "FiraCode Nerd Font";
      # name = "JetBrainsMono Nerd Font";
      size = 11;
    };

    settings = {
      background = "#282828";
      foreground = "#ebdbb2";

      color0 = "#282828";
      color8 = "#928374";
      # DarkRed + Red";
      color1 = "#cc241d";
      color9 = "#fb4934";
      # DarkGreen + Green";
      color2 = "#98971a";
      color10 = "#b8bb26";
      # DarkYellow + Yellow";
      color3 = "#d79921";
      color11 = "#fabd2f";
      # DarkBlue + Blue";
      color4 = "#458588";
      color12 = "#83a598";
      # DarkMagenta + Magenta";
      color5 = "#b16286";
      color13 = "#d3869b";
      # DarkCyan + Cyan";
      color6 = "#689d6a";
      color14 = "#8ec07c";
      # LightGrey + White";
      color7 = "#a89984";
      color15 = "#ebdbb2";
    };
  };

  # services.wallpaper.enable = true;

}
