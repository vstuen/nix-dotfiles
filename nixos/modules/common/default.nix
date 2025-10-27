# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs-unstable,
  pkgs,
  customHostConfig,
  username,
  ...
}:

{
  imports = [
    ../docker
    ../1password
  ];

  # Enable support for Flakes
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      # Increase download buffer to avoid warnings during large downloads
      download-buffer-size = 268435456; # 256 MB (default is usually 64 MB)
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = customHostConfig.hostName; # Define your hostname.
  networking.hostId = customHostConfig.hostId;
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Additional hardware configuration
  hardware.logitech.wireless.enable = true;
  hardware.keyboard.qmk.enable = true;

  # disable the wait online service, as it has started causing switch rebuild to fail
  # for more info see: https://github.com/NixOS/nixpkgs/issues/180175
  # another workaround might be to manually set the service to not run nm-online with the -s flag,
  # which makes it wait for the NetworkManager service.
  systemd.services.NetworkManager-wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "no";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Desktop
  services.xserver = {
    enable = true;
    # Configure keymap in X11
    xkb.layout = "no";
    xkb.variant = "nodeadkeys";
    xkb.options = "compose:menu";
    autorun = true;
  };

  services.tailscale = {
    enable = true;

    extraUpFlags = [
      # "--ssh"

    ];
  };

  # Thunderbolt
  services.hardware.bolt.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  ### Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Keyboard remapping
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          global = {
            # Make the tap action timeout on 200 ms for overloads,
            # so that it won't be activated if held down for longer
            # (which is the default behavior)
            overload_tap_timeout = 200;
          };
          main = {
            # Tap for ESC, hold for altgr
            capslock = "overload(altgr, esc)";
          };
        };
      };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "networkmanager"
      "adbusers"
      "audio"
      "plugdev"
    ];
    packages = with pkgs; [
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = (with pkgs; [
    vim
    wget
    curl
    git
    tree # list directories in a tree-like format
    htop
    libnotify
    killall # kill processes by name
    sshfs # mount remote filesystems over ssh
    mbuffer # buffers I/O and displays throughput
    iperf # network throughput measurements
    atool # archive tool wrapper, for apack, aunpack, als, acat, etc.
    zip
    unzip
    p7zip
    ripgrep
    pciutils
  ])
  ++
  (with pkgs-unstable; [
    neovim
  ]);

  # Environment
  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  # Programs
  programs.fish.enable = true;
  # Use fish as the default shell if interactive and not already running fish
  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  programs.appgate-sdp.enable = true;
  programs.command-not-found.enable = true;
  programs.nm-applet.enable = true;
  # programs.seahorse.enable = true; # disalbed when using plasma 6
  programs.adb.enable = true;

  # Default applications
  xdg.mime.defaultApplications = {
    "inode/directory" = "thunar.desktop";
  };

  # Virtualization
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Firmware updater
  services.fwupd.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };
  programs.ssh.startAgent = true;

  # Enable polkit
  security.polkit.enable = true;

  # Open ports in the firewall.
  networking.firewall = {
    allowedTCPPorts = [
      22
      3000
      8080
      8081
    ];
    allowPing = true;
  };

  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
