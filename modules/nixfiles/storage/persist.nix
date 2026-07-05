{
  den.quirks.persist.description = "Files/directories that must survive an impermanence wipe";

  # For hosts using nix-community/preservation (bind-mounts a persistent
  # subvolume back over an ephemeral root).
  nf.storage.preservation = {
    nixos =
      { persist, lib, ... }:
      {
        preservation.enable = true;
        preservation.preserveAt."/persist" = {
          files = [
            {
              file = "/etc/machine-id";
              inInitrd = true;
              how = "symlink";
              configureParent = true;
            }
            {
              file = "/etc/ssh/ssh_host_rsa_key";
              how = "symlink";
              configureParent = true;
            }
            {
              file = "/etc/ssh/ssh_host_rsa_key.pub";
              how = "symlink";
              configureParent = true;
            }
            {
              file = "/etc/ssh/ssh_host_ed25519_key";
              how = "symlink";
              configureParent = true;
            }
            {
              file = "/etc/ssh/ssh_host_ed25519_key.pub";
              how = "symlink";
              configureParent = true;
            }
          ]
          ++ lib.concatMap (p: p.files or [ ]) persist;

          directories = lib.concatMap (p: p.directories or [ ]) persist;
        };
      };
  };

  # For hosts using nix-community/impermanence (wipes root on boot, bind-mounts
  # the listed paths in from a persistent store).
  nf.storage.persistence = {
    nixos =
      { persist, lib, ... }:
      {
        environment.persistence."/persist/system" = {
          hideMounts = true;

          files = [
            "/etc/machine-id"
            "/etc/ssh/ssh_host_rsa_key"
            "/etc/ssh/ssh_host_rsa_key.pub"
            "/etc/ssh/ssh_host_ed25519_key"
            "/etc/ssh/ssh_host_ed25519_key.pub"
          ]
          ++ lib.concatMap (p: p.files or [ ]) persist;

          directories = lib.concatMap (p: p.directories or [ ]) persist;
        };
      };
  };
}
