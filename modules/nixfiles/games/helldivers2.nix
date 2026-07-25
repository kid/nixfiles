{
  nf.games.helldivers2 = {
    homeManager = _: {
      services.xremap = {
        mouse = true;
        config = {
          virtual_modifiers = [ "BTN_TASK" ];
          keymap = [
            {
              application.only = [ "steam_app_553850" ];
              remap = {
                BTN_TASK-BTN_LEFT = "m";
                BTN_TASK-XLeftScroll = "y";
                BTN_TASK-XDownScroll = "j";
                BTN_TASK-XUpScroll = "k";
                BTN_TASK-XRightScroll = "o";
              };
            }
          ];
        };
      };
    };
  };
}
