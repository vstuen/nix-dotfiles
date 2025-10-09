{ username, ... }: {
  imports = [
    ./zfs.nix
    ./hardware.nix
    ../../modules/common
    # ../../modules/gnome  # replaced by cosmic desktop
    ../../modules/cosmic
  ];

  hardware.openrazer.enable = true;
  users.users.${username}.extraGroups = [ "openrazer" ];
}
