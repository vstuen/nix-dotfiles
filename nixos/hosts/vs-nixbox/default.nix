{ username, ... }: {
  imports = [
    ./zfs.nix
    ./hardware.nix
    ./graphics.nix
    ../../modules/common
    ../../modules/gnome
    ../../modules/steam
  ];

  hardware.openrazer.enable = true;
  users.users.${username}.extraGroups = [ "openrazer" ];
}
