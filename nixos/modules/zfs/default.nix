{
  boot.supportedFilesystems = [ "zfs" ];
  services.sanoid.enable = true;
  services.sanoid.templates.system = {
    autosnap = true;
    autoprune = true;
    daily = 3;
    monthly = 1;
    hourly = 0;
  };
}
