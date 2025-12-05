{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    janet
    jpm
    cljfmt
    just
    hyperfine
    pkg-config
    rlwrap
  ];

  shellHook = ''
    echo -e "\x1b[1mDevelopment environment loaded\x1b[0m"
  '';
}
