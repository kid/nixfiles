{
  inputs,
  den,
  nf,
  ...
}:
{
  den.hosts.x86_64-linux.vulkan = {
    users.kid = { };
  };

  den.aspects.vulkan = {
    includes = [
      den._.hostname
      nf.base
      nf.stylix
      nf.desktop.gaming
      nf.dev.incus
      nf.storage.preservation
    ];

    persist.directories = [
      "/var/lib/libvirt"
      "/var/lib/systemd/coredump"
      "/var/lib/systemd/rfkill"
      "/var/lib/systemd/timers"
    ];

    nixos.imports = [
      ./_configuration.nix
      (import ./_disko-config.nix { })
    ]
    ++ (with inputs.nixos-hardware.nixosModules; [
      common-pc
      common-pc-ssd
      common-cpu-amd
      common-cpu-amd-pstate
      common-gpu-amd
    ]);

    # configurationRevision = inputs.self.shortRev or inputs.self.dirtyShortRev or "dirty";
    # nixos.label = "${config.system.nixos.version}-nixfiles-${config.system.configurationRevision}";
  };
}
