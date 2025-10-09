{
  imports = [ ../../modules/zfs ];
  
  # snapshots
  services.sanoid.datasets = {
    "zpool/home" = {
      autosnap = true;
      autoprune = true;
      hourly = 3;
      daily = 3;
      monthly = 1;

      # Create snapshots for each of the child datasets in home
      recursive = true;
      processChildrenOnly = true;
    };

    "zpool/root".useTemplate = [ "system" ];
    "zpool/var".useTemplate = [ "system" ];
    "zpool/nix".useTemplate = [ "system" ];
  };
}
