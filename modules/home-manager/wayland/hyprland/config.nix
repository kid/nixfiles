{ config, ... }:
let
  pointer = config.home.pointerCursor;
in
{
  wayland.windowManager.hyprland.extraConfig = ''
    # env = XCURSOR_SIZE,24

    env = GDK_BACKEND,wayland,x11
    env = QT_QPA_PLATFORM,wayland;xcb
    env = SDL_VIDEODRIVER,wayland

    env = XDG_CURRENT_DESKTOP,Hyprland
    env = XDG_SESSION_DESKTOP,Hyprland
    env = XDG_SESSION_TYPE,wayland

    env = GBM_BACKEND,nvidia-drm
    env = LIBVA_DRIVER_NAME,nvidia
    env = __GLX_VENDOR_LIBRARY_NAME,nvidia
    env = __GL_GSYNC_ALLOWED,1
    # env = __GL_VRR_ALLOWED,1
    env = WLR_DRM_NO_ATOMIC,1
    env = WLR_NO_HARDWARE_CURSORS,1

    exec = hyprctl setcursor ${pointer.name} ${toString pointer.size}

    exec-once = eww open bar
    exec-once = dunst
    exec-once = wl-paste --type text --watch cliphist store #Stores only text data
    exec-once = wl-paste --type image --watch cliphist store #Stores only image data
    exec-once = [workspace 9 silent] discord
    exec-once = telegram-desktop
    # exec-once = discordcanary

    monitor=HDMI-A-1, disable
    monitor=DP-3, 3840x1600@120, 0x0, 1, bitdepth, 10

    windowrulev2 = workspace 9  silent,class:^(discord)$
    windowrulev2 = workspace 10 silent,class:^(org.telegram.desktop)$
    windowrulev2 = tile,class:^.+-winbox64.exe$
    windowrulev2 = float,class:^(org.telegram.desktop)$,title:^(Media viewer)$

    bind = SUPER, T, exec, kitty
    bind = SUPER, P, exec, rofi -show
    # bind = SUPER, B, exec, google-chrome-beta --enable-features=UseOzonePlatform --ozone-platform=wayland
    bind = SUPER, B, exec, chromium -ozone-platform=wayland
    # bind = SUPER_SHIFT, B, exec, google-chrome-beta --enable-features=UseOzonePlatform --ozone-platform=wayland --incognito
    bind = SUPER_SHIFT, B, exec, chromium --ozone-platform=wayland --incognito
    bind = SUPER_SHIFT, Q, exec, ~/.config/hypr/scripts/quit.sh
    bind = SUPER, backslash, layoutmsg, togglesplit
    bind = SUPER_SHIFT, backslash, exec, ~/.config/hypr/scripts/switch-layout.sh
    bind = SUPER, W, killactive
    bind = SUPER, F, fullscreen
    bind = SUPER, space, togglefloating
    # bind = SUPER, J, cyclenext
    # bind = SUPER, K, cyclenext, prev
    bind = SUPER, J, layoutmsg, cyclenext
    bind = SUPER, K, layoutmsg, cycleprev
    # bind = SUPER_SHIFT, J, swapnext
    # bind = SUPER_SHIFT, K, swapnext, prev
    bind = SUPER_SHIFT, J, layoutmsg, swapnext
    bind = SUPER_SHIFT, K, layoutmsg, swapprev
    bind = SUPER, M, layoutmsg, focusmaster
    bind = SUPER_SHIFT, M, layoutmsg, swapwithmaster
    bind = SUPER, H, layoutmsg, orientationprev
    bind = SUPER, L, layoutmsg, orientationnext
    bind = SUPER, I, layoutmsg, addmaster
    bind = SUPER, D, layoutmsg, removemaster
    bind = SUPER, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy

    # Switch workspaces with mainMod + [0-9]
    bind = SUPER, 1, workspace, 1
    bind = SUPER, 2, workspace, 2
    bind = SUPER, 3, workspace, 3
    bind = SUPER, 4, workspace, 4
    bind = SUPER, 5, workspace, 5
    bind = SUPER, 6, workspace, 6
    bind = SUPER, 7, workspace, 7
    bind = SUPER, 8, workspace, 8
    bind = SUPER, 9, workspace, 9
    bind = SUPER, 0, workspace, 10

    # Move active window to a workspace with mainMod + SHIFT + [0-9]
    bind = SUPER_SHIFT, 1, movetoworkspace, 1
    bind = SUPER_SHIFT, 2, movetoworkspace, 2
    bind = SUPER_SHIFT, 3, movetoworkspace, 3
    bind = SUPER_SHIFT, 4, movetoworkspace, 4
    bind = SUPER_SHIFT, 5, movetoworkspace, 5
    bind = SUPER_SHIFT, 6, movetoworkspace, 6
    bind = SUPER_SHIFT, 7, movetoworkspace, 7
    bind = SUPER_SHIFT, 8, movetoworkspace, 8
    bind = SUPER_SHIFT, 9, movetoworkspace, 9
    bind = SUPER_SHIFT, 0, movetoworkspace, 10

    bind = SUPER + ALT, H, layoutmsg, preselect l
    bind = SUPER + ALT, L, layoutmsg, preselect r
    bind = SUPER + ALT, J, layoutmsg, preselect d
    bind = SUPER + ALT, K, layoutmsg, preselect u
    bind = SUPER + ALT, backslash, layoutmsg, preselect 0

    bind = SUPER, R, submap, resize
    submap=resize
    binde=,L,resizeactive,16 0
    binde=,H,resizeactive,-16 0
    binde=,K,resizeactive,0 -16
    binde=,J,resizeactive,0 16
    bind=,escape,submap,reset
    submap=reset

    # Super + LMB move window
    bindm=SUPER,mouse:272,movewindow
    # Super + LMB move window
    bindm=SUPER,mouse:273,resizewindow


    general {
      allow_tearing = true
      layout = master
      col.active_border = rgb(8ec07c)
      col.inactive_border = rgb(282828)
    }

    dwindle {
      # always split to the right
      force_split = 2

      # needed for togglesplit
      preserve_split = true

      permanent_direction_override = true

      no_gaps_when_only = true
    }

    master {
      # allow_small_split = true
      no_gaps_when_only = true
      new_is_master = false
      new_on_top = true
      # orientation = center
      # mfact = 0.6
    }  

    plugin {
      hy3 {
        no_gaps_when_only = true
      }
    }
  '';
}
