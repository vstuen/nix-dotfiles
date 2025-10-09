{
  description = "Utility scripts flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    # Use flake-utils to generate outputs for each supported system
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        pythonPkgs = pkgs.python3Packages;
        vstuenPyscripts = pythonPkgs.buildPythonPackage {
          pname = "vstuen-pyscripts";
          version = "0.1";
          src = self;
          propagatedBuildInputs = with pythonPkgs; [ setuptools bcrypt requests argcomplete ];
          meta = with pkgs.lib; {
            description = "A Python package for my scripts";
            homepage = "https://github.com/vstuen/nix-dotfiles/tree/master/home/modules/scripts";
            license = licenses.mit;
          };

          # Post-install hook to generate shell completions.
          postInstall = ''
            export PATH=${pythonPkgs.argcomplete}/bin:$PATH
            bash ${toString ./build-scripts/generate_completions.sh} $out
          '';
        };
      in {
        # 1. Build the Python package
        packages = {
          vstuen-pyscripts = vstuenPyscripts;
          default = vstuenPyscripts;
        };

        # 2. A development shell including the package (and its dependencies)
        devShell = pkgs.mkShell {
          buildInputs = [ vstuenPyscripts ];
        };
      });
}
