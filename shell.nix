{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    janet
    jpm
    cljfmt
  ];

  shellHook = ''
    echo "Development environment loaded"
  '';
}
