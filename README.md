# Nix Dotfiles

A declarative configuration for NixOS systems and Home Manager using Nix flakes.

## Repository Structure

```
.
├── flake.nix                 # Main flake configuration
├── flake.lock                # Flake input locks
├── home/                     # Home Manager configurations
│   ├── hosts/                # Host-specific home configurations
│   │   ├── vs-nixbox/        # Desktop workstation
│   │   ├── vs-nixtop/        # Laptop configuration
│   │   └── vs-worktop/       # Work laptop configuration
│   └── modules/              # Reusable home modules
│       ├── common/           # Shared packages and configurations
│       ├── dotnet-dev/       # .NET development environment
│       ├── fish/             # Fish shell configuration
│       ├── gnome/            # GNOME desktop environment
│       ├── hyprland/         # Hyprland window manager
│       ├── nvim/             # Neovim configuration
│       ├── plasma/           # KDE Plasma desktop
│       ├── razerkb/          # Razer keyboard configuration
│       ├── scripts/          # Custom Python scripts
│       └── vscode/           # VS Code configuration
└── nixos/                    # NixOS system configurations
    ├── hosts/                # Host-specific system configurations
    │   ├── vs-nixbox/        # Desktop system config
    │   ├── vs-nixtop/        # Laptop system config
    │   └── vs-worktop/       # Work laptop system config
    └── modules/              # Reusable system modules
        ├── common/           # Shared system configurations
        ├── cosmic/           # COSMIC desktop environment
        ├── docker/           # Docker configuration
        ├── gnome/            # GNOME system configuration
        ├── hyprland/         # Hyprland system configuration
        ├── plasma/           # KDE Plasma system configuration
        ├── steam/            # Steam gaming configuration
        └── zfs/              # ZFS filesystem configuration
```

## Quick Start

### Initial Setup

1. Clone this repository:
   ```bash
   git clone https://github.com/vstuen/nix-dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. For NixOS systems, rebuild with your host configuration:
   ```bash
   sudo nixos-rebuild switch --flake .#<hostname>
   # Or if your hostname matches the flake configuration:
   sudo nixos-rebuild switch --flake .
   ```

3. For Home Manager, switch to your user configuration:
   ```bash
   home-manager switch --flake .#<username>@<hostname>
   # Or if your hostname matches the flake configuration:
   home-manager switch --flake .
   ```

## Common Commands

### System Management (NixOS)

> **Note**: If your machine's hostname matches a configuration in the flake, you can omit the hostname and use just `--flake .` instead of `--flake .#<hostname>`

```bash
# Rebuild and switch to new configuration
sudo nixos-rebuild switch --flake .#<hostname>
# Or if hostname matches: sudo nixos-rebuild switch --flake .

# Rebuild and switch to new configuration on next boot
sudo nixos-rebuild boot --flake .#<hostname>

# Build configuration without switching
sudo nixos-rebuild build --flake .#<hostname>

# Test configuration (temporary, reverts on reboot)
sudo nixos-rebuild test --flake .#<hostname>

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# List system generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

### Home Manager

> **Note**: If your machine's hostname and username match a configuration in the flake, you can omit them and use just `--flake .` instead of `--flake .#<username>@<hostname>`

```bash
# Switch to new home configuration
home-manager switch --flake .#<username>@<hostname>
# Or if hostname/username match: home-manager switch --flake .

# Build configuration without switching
home-manager build --flake .#<username>@<hostname>

# List home manager generations
home-manager generations

# Rollback to previous generation
home-manager switch --flake .#<username>@<hostname> --generation <number>
```

### Flake Management

```bash
# Update all flake inputs
nix flake update

# Update specific input
nix flake update <input-name>

# Show flake info
nix flake show

# Check flake
nix flake check
```

### Garbage Collection

```bash
# Clean up old generations and unused packages
sudo nix-collect-garbage -d

# Clean up home manager generations
home-manager expire-generations "-30 days"

# Optimize nix store
sudo nix-store --optimise
```

## Host Configurations

### Available Hosts

- **vs-nixbox**: Gaming/Desktop workstation with GNOME, Steam, and development tools
- **vs-nixtop**: Laptop configuration with power management optimizations
- **vs-worktop**: Work laptop with development environments and productivity tools

### Adding a New Host

1. Create host-specific configurations:
   ```bash
   mkdir -p nixos/hosts/<new-host>
   mkdir -p home/hosts/<new-host>
   ```

2. Add the host to `flake.nix`:
   ```nix
   nixosConfigurations.<new-host> = nixpkgs.lib.nixosSystem {
     # ... configuration
   };
   
   homeConfigurations."<username>@<new-host>" = home-manager.lib.homeManagerConfiguration {
     # ... configuration
   };
   ```

## Module System

### NixOS Modules

Located in `nixos/modules/`, these modules configure system-level settings and services. They handle everything that requires root privileges or affects the entire system, such as:

- System services and daemons
- Desktop environments and display managers
- Hardware configuration and drivers
- Network and security settings
- System-wide package installations

Each module can be imported into host configurations as needed, allowing for flexible system composition.

### Home Manager Modules

Located in `home/modules/`, these modules configure user-space applications and environments. They manage:

- User-specific application configurations
- Development environment setups
- Shell configurations and dotfiles
- Desktop application preferences
- Personal scripts and utilities

These modules are composable and can be mixed and matched across different host configurations to create tailored user environments.

## Development Workflow

### Making Changes

1. Edit configurations in the appropriate module
2. Test the changes:
   ```bash
   # For system changes
   sudo nixos-rebuild test --flake .#<hostname>
   
   # For home changes
   home-manager switch --flake .#<username>@<hostname>
   ```
3. If satisfied, make the changes permanent:
   ```bash
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

### Custom Packages

Custom packages are defined in `home/modules/common/nix/packages/`. To add a new package:

1. Create a new `.nix` file in the packages directory
2. Import it in the packages list
3. Add it to your host configuration

## Troubleshooting

### Common Issues

1. **Build failures after flake update**:
   ```bash
   nix flake update
   sudo nixos-rebuild switch --flake .#<hostname> --show-trace
   ```

2. **Home Manager activation failures**:
   ```bash
   home-manager switch --flake .#<username>@<hostname> --show-trace
   ```

3. **Rollback if something breaks**:
   ```bash
   sudo nixos-rebuild switch --rollback
   home-manager switch --generation <previous-generation>
   ```

### Useful Debugging Commands

```bash
# Show detailed error information
--show-trace

# Verbose output
--verbose

# Show what will be built/downloaded
--dry-run

## License

This configuration is provided as-is for educational and personal use.
