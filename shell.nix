{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    janet
    jpm
    cljfmt
    hyperfine
    pkg-config
  ];

  shellHook = ''
    echo "Development environment loaded"
  '';
}
