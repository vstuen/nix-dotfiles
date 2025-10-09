{ username, ... }: {
  imports = [
    ./zfs.nix
    ./hardware.nix
    ../../modules/common
    ../../modules/hyprland
    ../../modules/plasma
  ];

  hardware.openrazer.enable = true;
  users.users.${username}.extraGroups = [ "openrazer" ];
}
