hostname := `hostname -s`
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
  nix run {{private}} \#{{host}} build -- {{private}} {{args}}

test host=hostname *args:
  nix run {{private}} \#{{host}} test -- --ask {{private}} {{args}}

switch host=hostname *args:
  nix run {{private}} \#{{host}} switch -- --ask {{private}} {{args}}

boot host=hostname *args:
  nix run {{private}} \#{{host}} boot -- --ask {{private}} {{args}}
