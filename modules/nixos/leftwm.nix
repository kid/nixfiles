{
  # requirements for leftwm 

  services.xserver = {
    enable = true;
    libinput.enable = true;
    deviceSection = ''
      Option "VariableRefresh" "true"
    '';

    displayManager.startx.enable = true;
  };
}
