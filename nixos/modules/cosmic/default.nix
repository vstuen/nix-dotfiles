{ pkgs, ... }:
{
  # Enable Cosmic desktop (assuming available in unstable for now)
  services.xserver.enable = true;
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  # Disable GNOME specific services that might conflict if previously enabled
  services.xserver.desktopManager.gnome.enable = false;
  services.xserver.displayManager.gdm.enable = false;
}
