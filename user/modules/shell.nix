{ pkgs, ... }: {
  home.packages = with pkgs; [
    git
  ];

  programs.htop.enable = true;
  programs.htop.settings = {
    show_program_path = 0;
  };

  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;

  programs.zsh = {
    enable = true;
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-syntax-highlighting"; tags = [ defer:2 ]; }
        { name = "plugins/fancy-ctrl-z"; tags = [ from:oh-my-zsh ]; }
        { name = "Aloxaf/fzf-tab"; }
        { name = "agkozak/zsh-z"; }
      ];
    };
  };
} 
