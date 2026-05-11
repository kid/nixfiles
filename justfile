hostname := `hostname -s`

help:
  just -l

build host=hostname *args:
  nix run \#{{host}} build {{args}}

switch host=hostname *args:
  nix run \#{{host}} switch --ask {{args}}

boot host=hostname *args:
  nix run \#{{host}} boot --ask {{args}}
