{
  inputs = {
    nixpkgs = {
      url = "nixpkgs/nixos-25.05";
    };
    nixpkgs-unstable = {
      url = "nixpkgs/nixos-unstable";
    };
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    vstuen-scripts = {
      url = "path:./home/modules/scripts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, vstuen-scripts, ... }@inputs:
    let
      lib = nixpkgs.lib;
      unstable-lib = nixpkgs-unstable.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = { allowUnfree = true; };
      };
      hmlib = home-manager.lib;
      username = "vegard";

    in
    {

      nixosConfigurations = {
        vs-nixtop = lib.nixosSystem {
          inherit system;
          modules = [
            ./nixos/hosts/vs-nixtop
          ];
          specialArgs = {
            inherit pkgs-unstable username;
            customHostConfig = {
              hostName = "vs-nixtop";
              hostId = "f404a8c2";
            };
          };
        };

        vs-worktop = lib.nixosSystem {
          inherit system;
          modules = [
            ./nixos/hosts/vs-worktop
          ];
          specialArgs = {
            inherit pkgs-unstable username;
            customHostConfig = {
              hostName = "vs-worktop";
              hostId = "b74f5312";
            };
          };
        };

        vs-nixbox = unstable-lib.nixosSystem {
          inherit system;
          modules = [
            ./nixos/hosts/vs-nixbox
          ];
          specialArgs = {
            inherit pkgs-unstable username;
            customHostConfig = {
              hostName = "vs-nixbox";
              hostId = "a616c78e";
            };
          };
        };
      };

      homeConfigurations = {
        "vegard@vs-nixtop" = hmlib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home/hosts/vs-nixtop ];
          extraSpecialArgs = {
            inherit inputs pkgs-unstable username vstuen-scripts;
          };
        };

        "vegard@vs-worktop" = hmlib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home/hosts/vs-worktop ];
          extraSpecialArgs = {
            inherit inputs pkgs-unstable username vstuen-scripts;
          };
        };

        "vegard@vs-nixbox" = hmlib.homeManagerConfiguration {
          pkgs = pkgs-unstable;
          modules = [ ./home/hosts/vs-nixbox ];
          extraSpecialArgs = {
            inherit inputs pkgs-unstable username vstuen-scripts;
          };
        };
      };

    };
}
