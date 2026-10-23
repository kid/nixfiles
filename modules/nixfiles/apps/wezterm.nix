{
  nf.apps.wezterm = {
    homeManager =
      { inputs', ... }:
      let
        # WezTerm half of smart-splits.nvim's backend-wezterm, taken from the
        # same package the Neovim half comes from so both stay in lockstep.
        smart-splits = inputs'.neovim-flake.packages.smart-splits-backend-wezterm;
      in
      {
        programs.wezterm = {
          enable = true;
          extraConfig = ''
            -- Loaded from the store instead of wezterm.plugin.require, so the
            -- plugin's own lookup through wezterm.plugin.list() finds nothing and
            -- its sibling modules have to be put on package.path here.
            package.path = package.path .. ';${smart-splits}/plugin/?.lua'
            local smart_splits = dofile('${smart-splits}/plugin/init.lua')

            -- Plain table: Home Manager merges whatever this returns into its own
            -- config builder.
            local config = {
              use_fancy_tab_bar = false,
              hide_tab_bar_if_only_one_tab = true,
              command_palette_font_size = 11,
              mux_enable_ssh_agent = false,
            }

            smart_splits.apply_to_config(config, { at_edge = 'split' })

            return config
          '';
        };
      };
  };
}
