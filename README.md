# Nix Flake · LaTeX Dev Template

> texlive · texlab · latexmk · purr · git-hooks

A reproducible, declarative LaTeX dev shell powered by [purr](https://github.com/nixcafe/purr) + [git-hooks.nix](https://github.com/cachix/git-hooks.nix). One-shot init, zero global cruft — write your paper, let Nix handle the rest.

## Quick Start

```bash
gh repo create my-latex-project --template nixcafe/latex --clone
direnv allow
```

### Build Your Document

```bash
latexmk -pdf main.tex
```

## What's Inside

| Tool | Purpose |
|------|---------|
| `texlive` (scheme-medium) | LaTeX distribution with core packages |
| `latexmk` | Build automation (`latexmk -pdf main.tex`) |
| `texlab` | LSP language server |
| `chktex` | LaTeX linter |
| `latexindent` | LaTeX source formatter |
| `minted` | Code syntax highlighting via Pygments |
| `nixfmt` | Nix formatter |
| `deadnix` | Remove dead Nix code |
| `statix` | Nix linter |

- **Dev shell** — `develop/shells/default/` ships `texlive` (scheme-medium + latexmk + minted + latexindent + chktex), `texlab`, `nixfmt`, `deadnix`, and `statix` in `$PATH`.
- **Git hooks** — `develop/checks/git-hooks/` runs `nixfmt`, `deadnix`, and `statix` on every commit. The shell hook auto-installs them when you enter the dev shell.
- **direnv** — `.envrc` calls `use flake` for auto-loading the dev shell on `cd`.
- **Sample** — `main.tex` is a minimal document showing the basic structure.

## Customizing

### Change TeX Live Scheme

Edit `develop/shells/default/default.nix` and swap `scheme-medium` for a different scheme or add extra collections:

```nix
tex = pkgs.texlive.combine {
  inherit
    (pkgs.texlive)
    scheme-full
    # scheme-basic
    # collection-latexrecommended
    # collection-fontsrecommended
    latexmk
    minted
    latexindent
    chktex
    ;
};
```

For a minimal footprint use `scheme-basic` + your specific collections. For the full TeX Live suite use `scheme-full`.

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
  tex
  texlab
  nixfmt
  deadnix
  statix
  inkscape        # SVG → PDF
  gnuplot         # plots
  python3Packages.pygments  # minted code highlighting
];
```

## Project Structure

```
.
├── flake.nix
├── .envrc
├── .gitignore
├── statix.toml
├── main.tex
└── develop/
    ├── checks/
    │   └── git-hooks/
    │       └── default.nix
    └── shells/
        └── default/
            └── default.nix
```
