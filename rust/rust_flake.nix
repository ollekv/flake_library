{
  description = "Rust Development Shell";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url  = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      with pkgs;
      {
        devShells.default = mkShell {
          buildInputs = [
            openssl
            pkg-config
            (
              rust-bin.selectLatestNightlyWith (toolchain: toolchain.default.override {
                extensions = [
                  "rust-src"
                  "rust-analyzer"
                ];
              })
            )
          ];
        };
      }
    );
}

#To invoke the development shell, navigate to the directory where flake is located and type nix develop (or nix develop --experimental-features 'nix-command flakes').

#This will create a flake.lock file, which "pins" the repositories mentioned in inputs to their most recent git commits. You should be tracking both flake.nix and flake.lock in git for guaranteed reproducibility, and for the possibility to roll-back in case something does not work once you update the inputs. Should there be new commits in repositories, you would be able to update the inputs, for that simply run nix flake update. It will re-pin repositories to the latest commit revisions.

#Now, let's run cargo init. This will initialize git in our directory, create the Cargo.toml file, and the src/main.rs, that contains "Hello, world!" written in Rust. We can now compile our application and run via cargo run. It will print the compilation information on the first run, followed by Hello, world! in the shell.
