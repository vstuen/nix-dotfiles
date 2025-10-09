{
  imports = [ ../../modules/zfs ];

  # snapshots
  services.sanoid.datasets = {
    "rpool/home" = {
      autosnap = true;
      autoprune = true;
      hourly = 3;
      daily = 3;
      monthly = 1;

      # Create snapshots for each of the child datasets in home
      recursive = true;
      processChildrenOnly = true;
    };

    "rpool/root".useTemplate = [ "system" ];
    "rpool/var".useTemplate = [ "system" ];
    "rpool/nix".useTemplate = [ "system" ];
  };
}
