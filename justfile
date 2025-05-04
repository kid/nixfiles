flake := env('FLAKE', justfile_directory())
task := if os() == "linux" { "switch-nixos" } else { "switch-darwin" }

default:
    @just --list

update-all:
    nix flake update

switch-nixos:
    nh os switch .

switch-darwin:
    darwin-rebuild switch --flake .

run:
    just {{ task }}

# build the package, you must specify the package you want to build
[group('package')]
build pkg:
    nix build {{ flake }}#{{ pkg }} \
      --log-format internal-json \
      -v \
      |& nom --json

# build the iso image, you must specify the image you want to build
[group('package')]
iso image: (build "nixosConfigurations." + image + ".config.system.build.isoImage")
