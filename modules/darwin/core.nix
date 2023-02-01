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

  fonts.fontDir.enable = true;
}
