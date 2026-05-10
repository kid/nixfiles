{ inputs, ... }:
{
  imports = [ (inputs.den.namespace "nf" true) ];
}
