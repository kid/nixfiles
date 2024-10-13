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
