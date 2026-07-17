{ inputs, system, ... }:
inputs.git-hooks.lib.${system}.run {
  src = ../../..;

  hooks = {
    nixfmt-rfc-style.enable = true;
    deadnix.enable = true;
    statix.enable = true;
  };
}
