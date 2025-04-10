{ config, ... }:
{
  programs = {
    fish.enable = config.nixfiles.meta.fish;
    zsh.enable = config.nixfiles.meta.zsh;
  };
}
