{
  # greetd + noctalia-greeter in place of the sddm that nf.desktop.plasma enables.
  nf.desktop.noctalia-greeter = {
    # Sync's wallpaper copies and the remembered session (sync.toml).
    persist.directories = [
      {
        directory = "/var/lib/noctalia-greeter";
        user = "greeter";
        group = "greeter";
        mode = "0750";
      }
    ];

    nixos =
      { config, lib, ... }:
      {
        services.displayManager = {
          sddm.enable = lib.mkForce false;

          noctalia-greeter = {
            enable = true;
            settings = {
              # Matches the .desktop filename; otherwise the first discovered session (Plasma) wins.
              session.default = config.services.displayManager.defaultSession;
              # Same palette mapping as stylix's noctalia target.
              appearance = with config.lib.stylix.colors.withHashtag; {
                scheme = "Synced";
                theme_mode = if config.stylix.polarity == "dark" then "dark" else "light";
                font_family = config.stylix.fonts.sansSerif.name;
                palette = {
                  primary = base0D;
                  on_primary = base00;
                  secondary = base0E;
                  on_secondary = base00;
                  tertiary = base0C;
                  on_tertiary = base00;
                  error = base08;
                  on_error = base00;
                  surface = base00;
                  on_surface = base05;
                  surface_variant = base01;
                  on_surface_variant = base04;
                  outline = base03;
                  shadow = base00;
                  hover = base0C;
                  on_hover = base00;
                };
                wallpaper = {
                  path = "${config.stylix.image}";
                  fill_mode = "crop";
                };
              };
            };
          };
        };

        # pam_fprintd first in `login` lets a fingerprint log in without a password, so
        # pam_kwallet gets no key and kdewallet stays locked. Noctalia's lock screen also
        # authenticates against `login` and drives the reader itself over D-Bus.
        security.pam.services.login.fprintAuth = false;
      };
  };
}
