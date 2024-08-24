task := if os() == "linux" { "switch-nixos" } else { "switch-darwin" }

update-all:
    nix flake update

switch:
    just {{ task }}

switch-nixos:
    nh os switch .

switch-darwin:
    darwin-rebuild switch --flake .

default: switch
