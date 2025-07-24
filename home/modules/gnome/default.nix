{ pkgs, ... }: {
  imports = [
    ./theme.nix
  ];

  programs.gnome-shell = {
    enable = true;
    extensions = map (str: { package = pkgs.gnomeExtensions.${str}; }) [
      "dash-to-dock"
      "clipboard-indicator"
      "caffeine"
      "gsconnect"
      "appindicator"
      "color-picker"
    ];
  };

  home.packages = with pkgs; [
    dconf-editor
    gnome-terminal
    gnome-tweaks
    guake # drop-down terminal
    xclip
    resources # system monitoring (GTK, looks gnome-native)
  ];

  services.flameshot = {
    enable = true;
    settings = {
      General = {
        # disabledTrayIcon = true;
        showStartupLaunchMessage = false;
      };
    };
  };

  # Add a Tray target, which is wanted by some services but isn't available on wayland kde
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
}
