hostname := `hostname -s`

help:
  just -l

check:
  nix flake check

write:
  nix run \.#write-flake

build host=hostname *args:
  nix run \#{{host}} build -- {{args}}

test host=hostname *args:
  nix run \#{{host}} test -- --ask {{args}}

switch host=hostname *args:
  nix run \#{{host}} switch -- --ask {{args}}

boot host=hostname *args:
  nix run \#{{host}} boot -- --ask {{args}}
