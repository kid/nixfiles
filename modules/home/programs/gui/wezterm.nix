{
  localLib,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (localLib.programs) mkProgram;

  cfg = config.nixfiles.programs.gui.wezterm;
in
{
  options.nixfiles.programs.gui = {
    wezterm = mkProgram pkgs "wezterm" {
      enable.default = config.nixfiles.programs.gui.enable;
    };
  };

  config.programs.wezterm = mkIf cfg.enable {
    enable = true;
    extraConfig = ''
      local function is_vim(pane)
        -- this is set by the plugin, and unset on ExitPre in Neovim
        return pane:get_user_vars().IS_NVIM == 'true'
      end

      local direction_keys = {
        h = 'Left',
        j = 'Down',
        k = 'Up',
        l = 'Right',
      }

      local function split_nav(resize_or_move, key)
        return {
          key = key,
          mods = resize_or_move == 'resize' and 'META' or 'CTRL',
          action = wezterm.action_callback(function(win, pane)
            if is_vim(pane) then
              -- pass the keys through to vim/nvim
              win:perform_action({
                SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
              }, pane)
            else
              if resize_or_move == 'resize' then
                win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
              else
                win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
              end
            end
          end),
        }
      end

      return {
        -- front_end = "WebGpu",
        use_fancy_tab_bar = false,
        hide_tab_bar_if_only_one_tab = true,
        command_palette_font_size = ${builtins.toString config.stylix.fonts.sizes.terminal},
        mux_enable_ssh_agent = false,
        keys = {
          -- move between split panes
          split_nav('move', 'h'),
          split_nav('move', 'j'),
          split_nav('move', 'k'),
          split_nav('move', 'l'),
          -- resize panes
          split_nav('resize', 'h'),
          split_nav('resize', 'j'),
          split_nav('resize', 'k'),
          split_nav('resize', 'l'),
          -- disable fullscreen on Alt-Enter to keep Claude Code newlines on macOS
          ${lib.optionalString pkgs.stdenv.isDarwin "{ key = 'Enter', mods = 'ALT', action = 'DisableDefaultAssignment' },"}
        },
      }
    '';
  };
}
