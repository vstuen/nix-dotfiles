{pkgs, ...}: {
  imports = [
    ../../modules/common
    ../../modules/gnome
    ../../modules/razerkb
  ];

  home.packages = with pkgs; [
  ];

  programs.fish.shellAliases = {
  };
}
