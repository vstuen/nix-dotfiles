{config, pkgs, pkgs-unstable, lib, ...}: {
  programs.hyprland.enable = true;
  programs.hyprland.package = pkgs-unstable.hyprland;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = lib.mkDefault pkgs.kdePackages.sddm;
  };
  
  services.gnome.gnome-keyring.enable = if (!config.services.desktopManager.plasma6.enable) then true else false;
}
