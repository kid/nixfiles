{ inputs, den, ... }:
{
  imports = [
    inputs.den.flakeModule
    (inputs.den.namespace "nf" true)
  ];

  systems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];

  den.schema.user.includes = [ den._.mutual-provider ];
}
