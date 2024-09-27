{ inputs, config, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./fonts.nix
    ./editor.nix
    ./cli.nix
    ./git.nix
    ./ssh.nix
    ./firefox.nix
    ./nixvim.nix
  ];

  programs = {
    home-manager.enable = true;
    gpg.enable = true;
  };

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
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
        front_end = "WebGpu",
        use_fancy_tab_bar = false,
        command_palette_font_size = ${builtins.toString config.stylix.fonts.sizes.terminal},
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
        },
      }
    '';
  };

  xdg.enable = true;

  home.stateVersion = "22.05";
}
