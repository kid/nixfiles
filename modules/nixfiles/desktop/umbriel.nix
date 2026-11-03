{ inputs, nf, ... }:
{
  # Track the cachix branches without following nixpkgs, otherwise the binary caches miss.
  flake-file.inputs = {
    umbriel.url = "github:noctalia-dev/umbriel/cachix";
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
  };

  nf.desktop.umbriel = {
    includes = [ nf.desktop.wayland ];

    nixos = {
      imports = [ inputs.umbriel.nixosModules.default ];

      programs.umbriel.enable = true;
      services.upower.enable = true;

      nix.settings = {
        extra-substituters = [
          "https://umbriel.cachix.org"
          "https://noctalia.cachix.org"
        ];
        extra-trusted-public-keys = [
          "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };
    };

    homeManager =
      { config, lib, ... }:
      {
        imports = [
          inputs.umbriel.homeModules.default
          inputs.noctalia.homeModules.default
        ];

        # Theme comes from stylix's noctalia target; started by umbriel's autostart, not systemd,
        # so it does not show up inside Plasma.
        programs.noctalia = {
          enable = true;
          settings.wallpaper.enabled = true;
        };

        programs.umbriel = {
          enable = true;
          settings = {
            include.optional.files = [ "~/.config/umbriel/local.toml" ];
            general.autostart = [ "noctalia" ];
            layout = {
              mode = lib.mkDefault "scrolling";
              extent_presets = [
                0.333
                0.5
                0.667
              ];
              scrolling.default_extent_fraction = 0.5;
            };
            input.keyboard.numlock_toggle = true;
            appearance = {
              prefer_no_csd = true;
              border_width = 2;
              corner_radius = 10;
              blur = {
                enabled = true;
                optimized = true;
                passes = 2;
                radius = 3;
                noise = 0.02;
                brightness = 0.9;
                contrast = 0.9;
                saturation = 1.1;
              };
            };
            # Stylix has no Umbriel target: map the base16 palette manually.
            colors = with config.lib.stylix.colors.withHashtag; {
              background = base00;
              text_primary = base05;
              text_muted = base04;
              accent_primary = base0D;
              accent_secondary = base0A;
              warning = base0A;
              error = base08;
              backdrop = base00;
              border = {
                focused = base0D;
                unfocused = base02;
                outer = base01;
              };
              overview.badge = base0D;
              tab_bar = {
                background = base01;
                text = base04;
                active = base0D;
                active_text = base00;
                active_unfocused = base02;
                active_unfocused_text = base05;
                urgent = base08;
                urgent_text = base00;
              };
            };
            window_rule = [
              {
                blur = true;
                blur_optimized = true;
              }
              {
                match.app_id = "^dev.noctalia.Noctalia$";
                default_floating = true;
                default_floating_size_px = {
                  width = 1020;
                  height = 900;
                };
              }
            ];
            layer_rule = [
              {
                match.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$";
                blur = true;
                blur_ignore_alpha = 0.6;
                blur_optimized = false;
              }
            ];
            # Mirrors the neovim layout one layer up: C-hjkl focus, C-w hjkl swap, A-hjkl resize.
            # No bare "Mod" bind: it would fire when xremap swallows Super+T/B.
            keybinds =
              let
                noctalia = cmd: "spawn noctalia msg ${cmd}";
                once = action: {
                  inherit action;
                  repeat = false;
                };
                locked = action: {
                  inherit action;
                  allow_when_locked = true;
                };
                ws = lib.listToAttrs (
                  lib.concatMap (
                    n:
                    let
                      s = toString n;
                    in
                    [
                      (lib.nameValuePair "Mod+${s}" "workspace-switch ${s}")
                      (lib.nameValuePair "Mod+Shift+${s}" "window-move-to-workspace ${s}")
                    ]
                  ) (lib.range 1 9)
                );
              in
              ws
              // {
                # Apps: same keys as xremap, fallback when xremap is not running
                "Mod+T" = once "spawn wezterm";
                "Mod+Return" = once "spawn wezterm";
                "Mod+B" = once "spawn firefox";
                "Mod+Shift+B" = once "spawn firefox --private-window";
                # Shell
                "Mod+P" = once (noctalia "panel-toggle launcher");
                "Mod+Space" = once (noctalia "panel-toggle launcher");
                "Mod+V" = once (noctalia "panel-toggle clipboard");
                "Mod+N" = once (noctalia "panel-toggle control-center");
                "Mod+Escape" = once (noctalia "panel-toggle session");
                "Mod+Ctrl+Escape" = once (noctalia "session lock");
                "Mod+Shift+Escape" = {
                  action = "shortcuts-inhibit-toggle";
                  allow_when_inhibited = true;
                  repeat = false;
                };
                "Mod+Slash" = once "cheatsheet-toggle";
                "Alt+Tab" = noctalia "window-switcher hold";
                "Alt+Shift+Tab" = noctalia "window-switcher hold reverse";
                "Print" = once (noctalia "screenshot-region");
                "Shift+Print" = once (noctalia "screenshot-fullscreen");
                # Media keys via Noctalia OSD
                "XF86AudioRaiseVolume" = locked (noctalia "volume-up");
                "XF86AudioLowerVolume" = locked (noctalia "volume-down");
                "XF86AudioMute" = (locked (noctalia "volume-mute")) // {
                  repeat = false;
                };
                "XF86AudioPlay" = (locked (noctalia "media toggle")) // {
                  repeat = false;
                };
                "XF86AudioNext" = locked (noctalia "media next");
                "XF86AudioPrev" = locked (noctalia "media previous");
                "XF86MonBrightnessUp" = locked (noctalia "brightness-up");
                "XF86MonBrightnessDown" = locked (noctalia "brightness-down");
                "Mod+Q" = once "window-close";
                # Focus
                "Mod+H" = "window-focus-or-output-left";
                "Mod+J" = "window-focus-or-workspace-down";
                "Mod+K" = "window-focus-or-workspace-up";
                "Mod+L" = "window-focus-or-output-right";
                "Mod+Left" = "window-focus-or-output-left";
                "Mod+Down" = "window-focus-or-workspace-down";
                "Mod+Up" = "window-focus-or-workspace-up";
                "Mod+Right" = "window-focus-or-output-right";
                "Mod+Tab" = "window-focus-last";
                # Move
                "Mod+Shift+H" = "window-move-or-output-left";
                "Mod+Shift+J" = "window-move-or-workspace-down";
                "Mod+Shift+K" = "window-move-or-workspace-up";
                "Mod+Shift+L" = "window-move-or-output-right";
                "Mod+Shift+Left" = "window-move-or-output-left";
                "Mod+Shift+Down" = "window-move-or-workspace-down";
                "Mod+Shift+Up" = "window-move-or-workspace-up";
                "Mod+Shift+Right" = "window-move-or-output-right";
                # Swap
                "Mod+Ctrl+H" = "window-swap-left";
                "Mod+Ctrl+J" = "window-swap-down";
                "Mod+Ctrl+K" = "window-swap-up";
                "Mod+Ctrl+L" = "window-swap-right";
                # Resize
                "Mod+Alt+H" = "window-modify-primary-extent -0.05";
                "Mod+Alt+L" = "window-modify-primary-extent 0.05";
                "Mod+Alt+J" = "window-modify-secondary-extent 0.05";
                "Mod+Alt+K" = "window-modify-secondary-extent -0.05";
                "Mod+R" = "window-cycle-primary-extent";
                "Mod+Shift+R" = "window-cycle-primary-extent-back";
                # Window state
                "Mod+F" = once "window-toggle-fullscreen";
                "Mod+M" = once "window-toggle-maximize-to-edges";
                "Mod+Ctrl+F" = once "window-toggle-maximize";
                "Mod+Shift+F" = once "window-toggle-floating";
                "Mod+Alt+F" = once "window-focus-switch-floating";
                "Mod+Shift+P" = once "window-toggle-pinned";
                "Mod+C" = "column-center";
                # Columns / tabs
                "Mod+Comma" = "window-consume-left";
                "Mod+Period" = "window-consume-right";
                "Mod+Ctrl+Comma" = "window-consume-from-left";
                "Mod+Ctrl+Period" = "window-consume-from-right";
                "Mod+W" = once "column-toggle-tabbed";
                "Mod+BracketRight" = "column-focus-tab-next";
                "Mod+BracketLeft" = "column-focus-tab-previous";
                # Master layout
                "Mod+I" = "layout-master-count-increase";
                "Mod+D" = "layout-master-count-decrease";
                "Mod+Alt+Space" = once "workspace-set-layout toggle scrolling master";
                # Overview, pointer
                "Mod+O" = once "overview-toggle";
                "Mod+WheelUp" = "window-focus-left";
                "Mod+WheelDown" = "window-focus-right";
                # Scratchpad
                "Mod+Grave" = once "scratchpad-toggle";
                "Mod+Shift+Grave" = once "window-move-to-scratchpad";
                "Mod+Ctrl+Grave" = once "window-restore-from-scratchpad";
              };
          };
        };
      };
  };
}
