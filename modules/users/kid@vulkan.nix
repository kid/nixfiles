{
  den.aspects.kid.provides.vulkan.homeManager =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.incus
        pkgs.ollama-rocm
      ];
    };
}
