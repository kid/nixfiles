# ❄️ nixfiles

Declarative NixOS configurations built with [flake-parts](https://flake.parts/) and [den](https://den.denful.dev/).

This repo follows Den’s current host/user/aspect model:

- machines are declared under `den.hosts`
- reusable configuration is declared under `den.aspects`
- local reusable modules are exposed through the `nf` namespace

## How this repo is structured

- `flake.nix` wires in `inputs.den.flakeModule`
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

At the moment this flake exports NixOS configurations for those hosts.
The Den setup is still prepared for cross-platform use, and CI also evaluates `aarch64-darwin`.

## Common commands

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

Build a host package:

```bash
just build fw13
```

Build or switch with extra arguments forwarded to the runner:

```bash
just build fw13 -- --dry-run
just switch fw13 -- --verbose
```

Stage a boot entry instead of switching immediately:

```bash
just boot fw13
```

Run flake checks:

```bash
nix flake check
```

## Main dependencies

- [den](https://den.denful.dev/) for the host/user/aspect pipeline
- [home-manager](https://github.com/nix-community/home-manager) for user environments
- [disko](https://github.com/nix-community/disko) for declarative partitioning
- [impermanence](https://github.com/nix-community/impermanence) and [preservation](https://github.com/nix-community/preservation) for persistent state handling
- [stylix](https://github.com/danth/stylix) for system-wide theming
- [plasma-manager](https://github.com/nix-community/plasma-manager) for KDE configuration
- [sops-nix](https://github.com/Mic92/sops-nix) for secrets
- [treefmt-nix](https://github.com/numtide/treefmt-nix) for formatting

## Credits

This setup has been heavily inspired by:

- [isabelroses/dotfiles](https://github.com/isabelroses/dotfiles)
- [jakehamilton/config](https://github.com/jakehamilton/config)
