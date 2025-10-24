{ inputs, pkgs-unstable, ... }: {
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./plugins
    ./keymap.nix
    ./options.nix
  ];
  
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    nixpkgs.pkgs = pkgs-unstable;
    performance.combinePlugins.enable = true;
  };
}
