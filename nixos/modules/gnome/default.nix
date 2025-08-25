{ pkgs, lib, ... }:
{
  services.xserver.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
  services.xserver.desktopManager.gnome.enable = true;
  hardware.pulseaudio.enable = false;

  ## SSH Agent
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gcr-ssh-agent.enable = true;

  # make sure the classic agent is OFF everywhere
  programs.ssh.startAgent = lib.mkForce false;

  ## Package excludes
  environment.gnome.excludePackages = with pkgs; [
    orca
    # evince
    # file-roller
    geary
    gnome-disk-utility
    # seahorse
    # sushi
    # sysprof
    #
    # gnome-shell-extensions
    #
    # adwaita-icon-theme
    # nixos-background-info
    # gnome-backgrounds
    # gnome-bluetooth
    # gnome-color-manager
    # gnome-control-center
    # gnome-shell-extensions
    gnome-tour # GNOME Shell detects the .desktop file on first log-in.
    gnome-user-docs
    # glib # for gsettings program
    # gnome-menus
    # gtk3.out # for gtk-launch program
    # xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
    # xdg-user-dirs-gtk # Used to create the default bookmarks
    #
    baobab
    epiphany
    gnome-text-editor
    # gnome.gnome-calculator
    gnome-calendar
    # gnome-characters
    # gnome-clocks
    gnome-console
    gnome-contacts
    # gnome-font-viewer
    # gnome-logs
    gnome-maps
    gnome-music
    # gnome-system-monitor
    gnome-weather
    # loupe
    # nautilus
    gnome-connections
    simple-scan
    # snapshot
    totem
    yelp
    gnome-software
  ];
}
