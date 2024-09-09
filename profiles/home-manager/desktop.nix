{ pkgs, ... }:
{
  home.packages = with pkgs; [
    sops
    # azure-cli
    kubectl
    kubectx
    # kustomize
    # kustomize-sops
    # certbot-full
    winbox
    screen
    minicom
    go_1_23
    gopls
    nil
    nodejs
    unzip
    cargo

    nil
    nixd

    kcl
  ];

  programs.zsh.shellAliases = {
    k = "kubectl";
  };
}
