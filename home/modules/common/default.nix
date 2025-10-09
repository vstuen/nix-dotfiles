{
  inputs,
  config,
  pkgs,
  lib,
  pkgs-unstable,
  username,
  vstuen-scripts,
  ...
}:
let
  prospect_mail = import ./nix/packages/prospect.nix {
    inherit (pkgs) appimageTools fetchurl;
  };
  testcontainers-desktop = import ./nix/packages/testcontainers-desktop { inherit pkgs; };

  vstuenPyScripts = vstuen-scripts.packages.${pkgs.system}.vstuen-pyscripts;

in
{
  imports = [
    ../nvim
    ../vscode
    ../fish
  ];

  services.home-manager.autoExpire.enable = true;

  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.sessionVariables = { };
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.krew/bin"
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;

  home.packages =
    (with pkgs; [
      brave
      inputs.zen-browser.packages.x86_64-linux.beta

      # utilities
      dig
      jq
      yq
      fzf
      pv
      sd
      grex
      pv # monitor data progress through pipe
      fd # simple, fast and user-friendly alternative to find
      brightnessctl # control brightness of monitor, keyboard etc
      wev # input capture utility, like xev, for wayland
      tealdeer # tldr utility written in rust
      fastfetch # neofetch like utility
      btop # system monitor
      inetutils # telnet, whois etc
      asciinema # terminal recorder
      kooha # screen recorder with wayland support
      distrobox
      lsof
      httpie
      meld # simple merge tool

      vlc
      libation # Audible audiobook manager
      vial # keyboard configuration software

      copyq # clipboard manager
      pavucontrol # pulse audio volume control
      genymotion
      solaar # logitech device management
      postman
      obs-studio
      youtube-music

      # Creative tools
      gimp # the GNU Image Manipulation Program
      krita # painting program + image manipulation
      librecad # cad software, mostly for 2D drawings
      freecad
      blender

      # libreoffice
      libreoffice-qt
      hunspell
      hunspellDicts.en-us
      hunspellDicts.nb_NO

      # atuin # shell history synchronization - disabled for now as it causes issues on
      # zfs and can delay the shell prompt

      gnome-network-displays

      # K8S and cloud
      kubectl
      kubernetes-helm
      krew # kubectl plugin manager
      terraform
      awscli2
      ssm-session-manager-plugin # AWS CLI SSM plugin
      openssl

      gh
      gcompris

      # Dev
      jetbrains.idea-ultimate
      jetbrains.datagrip
      android-studio
      nixpkgs-fmt
      nixfmt-rfc-style
      gcc
      qrencode # QR code generator

      # Fonts
      font-awesome
      nerd-fonts.fira-code

      # Custom packages
      prospect_mail # outlook for web electron wrapper
      testcontainers-desktop
      vstuenPyScripts

      # Programming languages
      nodejs_20
    ])

    ++

      ### Unstable
      (with pkgs-unstable; [
        ## Productivity and work
        teams-for-linux # unofficial teams client for linux
        slack # want the latest version
        obsidian # markdown notes
        anytype # local-first, source-available PKM
        signal-desktop # messaging app

        ## Dev
        bruno # local postman alternative
        eksctl # need unstable version to get newest k8s versions
        kiro # IDE for Agentic AI workflows based on VS Code

        # Gamedev
        godot

        (azure-cli.withExtensions [
          azure-cli.extensions.bastion
          azure-cli.extensions.ssh
        ])
      ]);

  programs.firefox.enable = true;

  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    extensions = [
      { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # ublock origin
    ];
  };

  programs.bat.enable = true; # cat replacement with syntax highlighting
  programs.k9s.enable = true; # terminal k8s client
  programs.lazygit.enable = true; # terminal git client
  programs.visidata.enable = true; # terminal spreadsheet viewer

  services.remmina.enable = true;

  # Git
  programs.git = {
    enable = true;
    userEmail = "vegard.stuen@wideroe.no";
    userName = "Vegard Stuen";
    difftastic = {
      enable = true;
      display = "side-by-side-show-both";
    };
    extraConfig = {
      init = {
        defaultBranch = "master";
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.pandoc.enable = true;

  ####
  #### Terminal
  ####
  # Kitty config, written to .config/kitty/kitty.conf
  programs.kitty.enable = true;
  programs.kitty.settings = {
    background_opacity = "0.6";
    scrollback_lines = 10000;
    enable_audio_bell = false;
    update_check_interval = 0;
    confirm_os_window_close = 0;
  };

  # Alacritty
  programs.alacritty = {
    enable = true;
    settings = {
      # window.dimensions = {
      #   lines = 3;
      #   columns = 200;
      # };
      keyboard.bindings = [
        {
          key = "K";
          mods = "Control";
          chars = "\\u000c";
        }
      ];
    };
  };

  # Ghostty
  programs.ghostty = {
    enable = true;
    settings = {
      keybind = [
        # List keybinds here, currently the global: prefix is only supported on macOS
        # "global:ctrl+super+enter=toggle_quick_terminal"
      ];
    };
  };

  ### Config files
  xdg.configFile = {
    "nixpkgs/config.nix".source = ./nix/nixpkgs-config.nix;
  };

  home.file = {
    # executables that should be on the path
    ".local/bin" = {
      source = ./bin;
      recursive = true;
    };
    # executables that are used by other applications and should not be on the path
    ".local/scripts" = {
      source = ./scripts;
    };

  };

  # Systemd serviecs
  systemd.user = {
    startServices = "sd-switch";
    services.solaar = {
      Unit = {
        Description = "Solaar Logitech device manager";
        After = "graphical-session.target";
      };

      Service = {
        ExecStart = "${pkgs.solaar}/bin/solaar -w hide";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
