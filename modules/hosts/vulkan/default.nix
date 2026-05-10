{
  den,
  inputs,
  ...
}:
{
  den.hosts.x86_64-linux.vulkan = {
    users.kid = { };
  };

  den.aspects.vulkan = {
    includes = [
      den.aspects.base
      den.provides.hostname
    ];

    nixos.imports = [
      ./_configuration.nix
      ./_disko-config.nix
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
