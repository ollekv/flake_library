{ # run with nix develop and usevenv and pip to install packages
  # with fish shell, activate venv with ". venv/bin/activate.fish"

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
    in rec {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          python311Full
          python311Packages.pyqt5
        ];
        shellHook = ''
          # Fixes libstdc++ issues and libgl.so issues (//e.g. when running jupyter lab)
          export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib/:/run/opengl-driver/lib/
          # Fixes xcb issues
          export QT_PLUGIN_PATH=${pkgs.qt5.qtbase}/${pkgs.qt5.qtbase.qtPluginPrefix}
        '';
      };
    }
  );
}
