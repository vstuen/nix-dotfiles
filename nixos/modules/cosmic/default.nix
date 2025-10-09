{ lib, pkgs, ... }:
{
  # Enable Cosmic desktop (Wayland compositor) – xserver pulls in Xwayland for legacy apps
  services.xserver.enable = true;
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  # Make sure GNOME DE & GDM are off (we swapped from GNOME to Cosmic)
  services.xserver.desktopManager.gnome.enable = false;
  services.xserver.displayManager.gdm.enable = false;

  # Force-disable GNOME's gcr SSH agent to avoid conflict with programs.ssh.startAgent
  # This is safe even if the option doesn't exist (NixOS will ignore unknown options)
  services.gnome.gcr-ssh-agent.enable = lib.mkForce false;
}
