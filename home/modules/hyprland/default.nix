{ config, lib, pkgs, pkgs-unstable, ... }: {
  home.packages = (with pkgs; [
    xfce.thunar # file manager
    hypridle # idle monitoring daemon - triggers lock screen ++
    hyprshade # set shaders for hyprland, including blue-light-filter
    nwg-displays # monitor management for sway/hyprland
    ulauncher # application launcher
    waypaper # wallpaper selector for 
    swww # wallpaper engine
    nwg-look # GTK appearance
    polkit_gnome # polkit agent, to allow authentication requests
    swappy # screenshot editing tool
    grim # screenshots
    slurp # area selector, for screenshots
    wl-clipboard-rs # rust implementation of wl-clipboard (wl-copy / wl-paste)
    wl-clipboard-x11 # wl-clipboard wrapper for X11 tools
  ])
  ++
  ### Unstable 
  (with pkgs-unstable; [
    satty # screenshot editor
  ]);

  # Enable in home manager in addition to nixos configuration to get the hyprland session target
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      source = [
        "~/.config/hypr/hyprland/main.conf"
      ];
    };
    extraConfig = ''
      exec-once = env QT_QPA_PLATFORM=xcb copyq
      # exec-once = ${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1
      exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
    '';
  };


  ### Additional programs
  programs.waybar.enable = true; # status bar
  programs.hyprlock.enable = true; # screen locker

  # Rofi
  nixpkgs.overlays = [
    (final: prev: {
      rofi-calc = prev.rofi-calc.override { rofi-unwrapped = prev.rofi-wayland-unwrapped; };
    })
  ];
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = [
      pkgs.rofi-calc
    ];
    theme = lib.mkForce "rounded-nord-dark"; # Override catppuccin attribute
  };

  # Notification daemon
  services.mako = {
    enable = true;
    borderRadius = 3;
    borderSize = 1;
    # borderColor = "#b1b9ba77";
    # backgroundColor = "#1c1d1d99";
    # textColor = "#b1b9badd";

    defaultTimeout = 5000;
  };

  ### CONFIG Files
  xdg.configFile = {
    # ./hypr directory: mkOutOfStoreSymlink doesn't work well with recursive, so instead add each file
    # manually. We want the out of store symlink since hyprland doesn't seem to autorefresh properly 
    # without
    "hypr/hyprland/main.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/home/modules/hyprland/hypr/hyprland/main.conf";
    "hypr/hypridle.conf".source = ./hypr/hypridle.conf;
    "hypr/hyprlock.conf".source = ./hypr/hyprlock.conf;
    "satty/config.toml".source = ./satty/config.toml;

    waybar = {
      source = ./waybar;
      recursive = true;
    };


    waypaper = {
      source = ./waypaper;
      recursive = true;
    };

    ulauncher = {
      source = ./ulauncher;
      recursive = true;
    };
  };

  home.file = {
    ".local/share/rofi/themes" = {
      source = ./rofi/themes;
      recursive = true;
    };
  };

  # Systemd user services
  systemd.user.services = {
    ulauncher = {
      Unit = {
        Description = "Ulauncher";
        After = "hyprland-session.target";
      };

      Service = {
        ExecStart = "${pkgs.ulauncher}/bin/ulauncher --hide-window --no-window-shadow";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "hyprland-session.target" ];
      };
    };
  };
}
