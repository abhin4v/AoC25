{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    janet
    jpm
  ];

  shellHook = ''
    echo "Development environment loaded"
  '';
}
