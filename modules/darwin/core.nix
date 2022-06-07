{ pkgs, ... }:
{
  environment = {
    loginShell = pkgs.zsh;
  };

  # auto manage nixbld users with nix darwin
  users.nix.configureBuildUsers = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix = {
    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';

    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;

    linkInputs = true;
  };

  # https://github.com/LnL7/nix-darwin/issues/158
  # programs.zsh.shellInit = ''export OLD_NIX_PATH="$NIX_PATH";'';
  # programs.zsh.interactiveShellInit = ''
  #   if [ -n "$OLD_NIX_PATH" ]; then
  #     if [ "$NIX_PATH" != "$OLD_NIX_PATH" ]; then
  #       NIX_PATH="$OLD_NIX_PATH"
  #     fi
  #     unset OLD_NIX_PATH
  #   fi
  # '';

  fonts.fontDir.enable = true;

  environment.variables = {
    # https://github.com/nix-community/home-manager/issues/423
    TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
  };
}
