{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    janet
    jpm
    cljfmt
    hyperfine
    pkg-config
    rlwrap
  ];

  shellHook = ''
    echo "Development environment loaded"
  '';
}
