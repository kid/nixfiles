{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.nixfiles.hardware.audio;
in
{
  options.nixfiles.hardware.audio.enable = mkEnableOption "audio";

  config = mkIf cfg.enable {
    security.rtkit.enable = true;
    services = {
      pipewire = {
        enable = true;
        alsa.enable = true;
        audio.enable = true;
        jack.enable = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };
      pulseaudio.enable = lib.mkForce false;
    };
  };
}
