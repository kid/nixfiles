{ pkgs, ... }:
{
  environment = {
    loginShell = pkgs.zsh;
  };

  # auto manage nixbld users with nix darwin
  nix.configureBuildUsers = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      extra-platforms = x86_64-darwin aarch64-darwin
    '';

    # generateRegistryFromInputs = true;
    # generateNixPathFromInputs = true;

    # linkInputs = true;
  };

  fonts.fontDir.enable = true;
}
