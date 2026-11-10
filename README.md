# LaTeX document environment

Nix flake template for LaTeX documents. The dev shell provides a TeX Live installation based on `scheme-medium`, combined with `latexmk`, `minted`, `latexindent`, and `chktex`, plus `texlab` for editor support and `nixfmt`, `deadnix`, and `statix` for Nix files. The flake is built with [purr](https://github.com/nixcafe/purr) and uses [git-hooks.nix](https://github.com/cachix/git-hooks.nix) for pre-commit hooks.

Part of the [develop-templates](https://github.com/nixcafe/develop-templates) collection.

## Quick start

Create the project files in the current directory:

```bash
nix flake init -t "github:nixcafe/develop-templates#latex" --refresh
```

Register the collection once to use the shorter name:

```bash
nix registry add beans "github:nixcafe/develop-templates"
nix flake init -t beans#latex
```

With [cattery-modules](https://github.com/nixcafe/cattery-modules), `beans` is already registered.

You can also create a repository from the template repository:

```bash
gh repo create my-latex-project --template nixcafe-develop/latex --clone
```

Enter the dev shell:

```bash
nix develop
```

If direnv is installed, `direnv allow` loads the shell when you enter the directory. The template includes an `.envrc` that calls `use flake`.

The template does not include a `flake.lock`. The first `nix develop` resolves the inputs and writes one.

## Build the document

```bash
latexmk -pdf main.tex
```

This produces `main.pdf` from the sample document. `main.pdf` and the other LaTeX build artifacts are listed in `.gitignore`.

## What's included

| Tool | Purpose |
|------|---------|
| `texlive` (`scheme-medium`) | TeX Live base with core packages |
| `latexmk` | Build automation |
| `texlab` | LSP language server |
| `chktex` | LaTeX linter |
| `latexindent` | LaTeX source formatter |
| `minted` | Code highlighting through Pygments |
| `nixfmt` | Nix formatter |
| `deadnix` | Finds dead code in Nix files |
| `statix` | Nix linter |

`minted` calls Pygments while the document is compiled. Pygments is not included in the dev shell, so add `python3Packages.pygments` to the package list if you use `minted`. The sample `main.tex` does not use it.

The pre-commit hooks for `nixfmt`, `deadnix`, and `statix` are enabled in `develop/checks/git-hooks/default.nix`. The shell hook installs them when you enter the dev shell.

The flake also sets `allowUnfree = true` and uses `pkgs.nixfmt` as the formatter, so `nix fmt` formats the Nix files.

## Useful commands

```bash
nix develop                 # enter the dev shell
direnv allow                # load the shell through direnv
latexmk -pdf main.tex       # build main.pdf
latexmk -C                  # remove generated files
nix fmt                     # format Nix files with nixfmt
```

## Customizing

### Change the TeX Live scheme

Edit `develop/shells/default/default.nix` and replace `scheme-medium` with another scheme, or add collections:

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

Use `scheme-basic` with specific collections for a smaller installation, or `scheme-full` for the complete TeX Live set.

### Pin nixpkgs

`flake.nix` currently follows the FlakeHub `0.1.*` release of nixpkgs. Replace that input with a specific branch or commit when you need a fixed version:

```nix
# flake.nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  ...
};
```

### Add system packages

Add packages to the `packages` list in `develop/shells/default/default.nix`:

```nix
packages = with pkgs; [
  tex
  texlab
  nixfmt
  deadnix
  statix
  inkscape                  # SVG to PDF conversion
  gnuplot                   # plots
  python3Packages.pygments  # Pygments for minted
];
```

## Project structure

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
