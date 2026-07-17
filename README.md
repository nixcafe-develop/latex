# Nix Flake · LaTeX Dev Template

> purr · git-hooks · latex · texlive · nixfmt · deadnix · statix · direnv · flake · reproducible · template · pdf

A reproducible, declarative LaTeX dev shell powered by [purr](https://github.com/nixcafe/purr) + [git-hooks.nix](https://github.com/cachix/git-hooks.nix). One-shot init, zero global cruft — write your paper, let Nix handle the rest.

Part of the [develop-templates](https://github.com/nixcafe/develop-templates) collection (`nix flake init`-ready).
## What's Inside

| Tool | Purpose |
|------|---------|
| `nixfmt-rfc-style` | Nix formatter |
| `deadnix` | Remove dead Nix code |
| `statix` | Nix linter |

- **Dev shell** — `develop/shells/default/` ships `nixfmt-rfc-style`, `deadnix`, and `statix` in `$PATH`. `texlive` is provided by `nixpkgs`; add `texlive` packages to the shell (see [Customizing](#customizing)).
- **Git hooks** — `develop/checks/git-hooks/` runs `nixfmt-rfc-style`, `deadnix`, and `statix` on every commit. The shell hook auto-installs them when you enter the dev shell.
- **direnv** — `.envrc` calls `use flake` for auto-loading the dev shell on `cd`.

No language-specific formatters or linters are included — you pick your own LaTeX tooling (e.g. `texlab`, `chktex`, `latexindent`).

## Quick Start

### `nix flake init`

```bash
nix flake init -t "github:nixcafe/develop-templates#latex" --refresh
```

Register an alias:

```bash
nix registry add beans "github:nixcafe/develop-templates"
nix flake init -t beans#latex
```

> **Tip**: With [cattery-modules](https://github.com/nixcafe/cattery-modules), `beans` is pre-registered.

### Create from Template

```bash
gh repo create my-project --template nixcafe/latex --clone
```

### Enter the Dev Shell

```bash
direnv allow
# or without direnv:
nix develop
```

### Build Your Document

```bash
latexmk -pdf main.tex
```

## Customizing

### Add LaTeX Packages

Edit `develop/shells/default/default.nix` and wire up `texlive` with the scheme and collection(s) you need:

```nix
# develop/shells/default/default.nix
{
  inputs,
  pkgs,
  system,
  ...
}:
pkgs.mkShell {
  packages = with pkgs; [
    nixfmt-rfc-style
    deadnix
    statix
    (texlive.combine {
      inherit (texlive) scheme-medium collection-latexrecommended collection-fontsrecommended;
    })
  ];

  shellHook = ''
    ${inputs.self.checks.${system}.git-hooks.shellHook}
  '';
  buildInputs = inputs.self.checks.${system}.git-hooks.enabledPackages;
}
```

For a minimal footprint use `scheme-basic` + your specific collections. For the full TeX Live suite use `scheme-full`.

### Add Your Own Formatters

This template ships without LaTeX-specific formatters so you can choose what fits your workflow. Drop them into the shell packages:

```nix
packages = with pkgs; [
  nixfmt-rfc-style
  deadnix
  statix
  texlab        # LSP
  chktex        # linter
  latexindent   # formatter
  (texlive.combine { inherit (texlive) scheme-medium; })
];
```

Then enable the corresponding git hooks in `develop/checks/git-hooks/default.nix`:

```nix
hooks = {
  nixfmt-rfc-style.enable = true;
  deadnix.enable = true;
  statix.enable = true;
  # chktex.enable = true;
  # latexindent.enable = true;
};
```

### Pin a Specific nixpkgs Snap

```nix
# flake.nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  ...
};
```

### Add System Packages

```nix
# develop/shells/default/default.nix
packages = with pkgs; [
  nixfmt-rfc-style
  deadnix
  statix
  inkscape        # SVG → PDF
  gnuplot         # plots
  python3Packages.pygments  # minted code highlighting
  (texlive.combine { inherit (texlive) scheme-full; })
];
```

## Project Structure

```
.
├── flake.nix
├── .envrc
├── .gitignore
├── statix.toml
└── develop/
    ├── shells/
    │   └── default/
    │       └── default.nix
    └── checks/
        └── git-hooks/
            └── default.nix
            └── default.nix
```
