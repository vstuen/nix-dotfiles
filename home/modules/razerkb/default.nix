{ pkgs, ... }: {
  home.packages = (with pkgs; [ polychromatic ]);
}
