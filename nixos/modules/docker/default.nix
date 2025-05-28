{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    docker-compose # Needed by some processes, but podman dockerCompat does not provide this
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  environment.sessionVariables = {
    # At login, PAM will expand $XDG_RUNTIME_DIR to "/run/user/<uid>"
    DOCKER_HOST = "unix://\${XDG_RUNTIME_DIR}/podman/podman.sock";
  };

  # virtualisation.docker = {
  #   enable = true;
  #   rootless = {
  #     enable = true;
  #     setSocketVariable = true;
  #   };
  # };
}