# ❄️ nixfiles

Declarative NixOS configurations built with [flake-parts](https://flake.parts/), [den](https://den.denful.dev/), and [flake-file](https://github.com/denful/flake-file).

This repo follows Den’s current host/user/aspect model:

- machines are declared under `den.hosts`
- reusable configuration is declared under `den.aspects`
- local reusable modules are exposed through the `nf` namespace

## How this repo is structured

- `flake-file.nix` declares flake inputs for the generated `flake.nix`
- `outputs.nix` is the hand-written flake entrypoint
- `modules/den.nix` enables Den and registers the local `nf` namespace
- `modules/hosts/*` defines hosts such as `fw13` and `vulkan`
- `modules/users/*` defines user aspects, mainly `kid`
- `modules/nixfiles/*` contains reusable local aspects like `nf.base`, `nf.stylix`, `nf.apps.firefox`, and `nf.ai.pi`

In practice, hosts are very small and mostly just compose aspects:

```nix
den.hosts.x86_64-linux.fw13 = {
  users.kid = { };
};

den.aspects.fw13 = {
  includes = [
    <den/hostname>
    <nf.base>
    <nf.stylix>
  ];
};
```

User configuration is also expressed as aspects and shared across hosts:

```nix
den.aspects.kid = {
  includes = [
    <den/define-user>
    <den/primary-user>
    <nf.apps/firefox>
    <nf.ai/pi>
  ];

  homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.opencode ];
  };
};
```

## Current hosts

- `fw13` — Framework 13 laptop
- `vulkan` — desktop/workstation

The work Mac (nix-darwin) is also built from this flake, but its host, user, and AI setup live in the private `kid/nixfiles-work` repo.
`modules/private.nix` imports `modules/` from the `private` input, which is the empty stub at `./private` unless overridden.
The `just` recipes override it with `~/Code/kid/nixfiles-work` (or `$NIXFILES_PRIVATE`) when that checkout exists.
Private modules must not declare `flake-file.inputs`, or `just write` would publish them in `flake.nix`.

## Common commands

The recipes call `nh` (`nh darwin` on macOS), which the dev shell provides (`nix develop`, or direnv).

List available recipes:

```bash
just help
```

Switch the current host (defaults to `$(hostname -s)`):

```bash
just switch
```

Switch a specific host:

```bash
just switch fw13
```

Build a host:

```bash
just build fw13
```

Build or switch with extra arguments forwarded to `nix build`:

```bash
just build fw13 -- --dry-run
just switch fw13 -- --verbose
```

Stage a boot entry instead of switching immediately:

```bash
just boot fw13
```

Regenerate `flake.nix` after changing flake inputs:

```bash
just write
```

Run flake checks:

```bash
just check
```

## AI memory

The shared AI aspect enables OMP's Mnemopi backend with global scoping.
All projects on the same machine share one local memory bank; memory is not synchronized between hosts.
Apply the Home Manager configuration and restart OMP to activate the settings.

## Main dependencies

- [flake-file](https://github.com/denful/flake-file) for generating `flake.nix` from typed module options
- [den](https://den.denful.dev/) for the host/user/aspect pipeline
- [home-manager](https://github.com/nix-community/home-manager) for user environments
- [disko](https://github.com/nix-community/disko) for declarative partitioning
- [impermanence](https://github.com/nix-community/impermanence) and [preservation](https://github.com/nix-community/preservation) for persistent state handling
- [stylix](https://github.com/danth/stylix) for system-wide theming
- [plasma-manager](https://github.com/nix-community/plasma-manager) for KDE configuration
- [sops-nix](https://github.com/Mic92/sops-nix) for secrets
- [srvos](https://github.com/nix-community/srvos) for the shared baseline (NixOS `desktop` profile plus Nix and boot mixins; darwin `desktop` profile only, since Macs run Determinate Nix)
- [treefmt-nix](https://github.com/numtide/treefmt-nix) for formatting
