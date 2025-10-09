{ pkgs, ... }: {
  # home.packages = (with pkgs; [
  home.packages = with pkgs; [
    kdePackages.yakuake
    kdePackages.ksshaskpass
  ];

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  home.sessionVariables = {
    SSH_ASKPASS = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
    GIT_ASKPASS = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
    SSH_ASKPASS_REQUIRE = "prefer";
  };

  

    # Add a Tray target, which is wanted by some services but isn't available on wayland kde
    systemd.user.targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = [ "graphical-session-pre.target" ];
      };
    };
}
