hostname := `hostname -s`
nh := if os() == "macos" { "nh darwin" } else { "nh os" }
# kid/nixfiles-work, swapped in for the stub at ./private when checked out.
private_dir := env("NIXFILES_PRIVATE", home_directory() / "Code/kid/nixfiles-work")
private := if path_exists(private_dir) == "true" { "--override-input private git+file://" + private_dir } else { "" }

help:
  just -l

check:
  nix flake check

write:
  nix run \.#write-flake

build host=hostname *args:
  {{nh}} build . --hostname {{host}} {{private}} {{args}}

test host=hostname *args:
  {{nh}} test . --hostname {{host}} --ask {{private}} {{args}}

switch host=hostname *args:
  {{nh}} switch . --hostname {{host}} --ask {{private}} {{args}}

boot host=hostname *args:
  {{nh}} boot . --hostname {{host}} --ask {{private}} {{args}}
