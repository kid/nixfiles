{
  nf.desktop.sddm = {
    persist.directories = [ "/var/lib/sddm" ];

    nixos.services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      settings.General.InputMethod = "";
    };
  };
}
