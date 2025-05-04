{ pkgs, lib, config, inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.system; };
in
{
  # https://devenv.sh/basics/
  env.GREET = "Olle's Python & UV workspace";

  # https://devenv.sh/packages/
  packages = [ pkgs-unstable.git ];

  # https://devenv.sh/languages/
  # languages.rust.enable = true;
  languages.python = {
    enable = true;
    version = "3.13";
    uv = {
      enable = true;
      package = pkgs-unstable.uv;
    };
  };

  # https://devenv.sh/processes/
  # processes.cargo-watch.exec = "cargo-watch";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    echo
    echo Activated $GREET
    echo
    '';

  enterShell = ''
    hello
    devenv --version
    git --version
    python --version
    uv --version
    echo
    '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  # https://devenv.sh/git-hooks/
  # git-hooks.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
