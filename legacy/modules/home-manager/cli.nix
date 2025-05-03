{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fd
    htop
    jq
    ripgrep
    pistol # For previews in lf
    gnumake
    gopls
    devenv
  ];
  programs = {
    gh = {
      enable = true;
      settings.git_protocol = "ssh";
      settings.version = 1;
    };

    htop.enable = true;
    btop.enable = true;
    bottom.enable = true;

    bat.enable = true;
    eza = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    k9s.enable = true;

    lf = {
      enable = true;
    };
  };
}
