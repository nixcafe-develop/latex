{
  inputs,
  pkgs,
  system,
  ...
}:
let
  tex = pkgs.texlive.combine {
    inherit
      (pkgs.texlive)
      scheme-medium
      latexmk
      minted
      latexindent
      chktex
      ;
  };
in
pkgs.mkShell {
  packages = with pkgs; [
    tex
    texlab
    nixfmt
    deadnix
    statix
  ];

  shellHook = ''
    ${inputs.self.checks.${system}.git-hooks.shellHook}
    echo "texlive ready"
  '';

  buildInputs = inputs.self.checks.${system}.git-hooks.enabledPackages;
}
