{ username, ... }: {
  imports = [
    ./zfs.nix
    ./hardware.nix
    ./graphics.nix
    ../../modules/common
    ../../modules/gnome
  ];

  hardware.openrazer.enable = true;
  users.users.${username}.extraGroups = [ "openrazer" ];
}
