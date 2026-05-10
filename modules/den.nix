{ inputs, den, ... }:
{
  imports = [ inputs.den.flakeModule ];

  systems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];

  # Enable angle brackets syntax
  _module.args.__findFile = den.lib.__findFile;

  den.schema.user.includes = [ den._.mutual-provider ];
}
