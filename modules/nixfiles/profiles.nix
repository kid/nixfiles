{ __findFile, ... }:
{
  nf.profiles._ = {
    workstation.includes = [
      <nf/base>
    ];
    desktop.includes = [
      <nf/profiles/workstation>
    ];
    laptop.includes = [
      <nf/profiles/workstation>
    ];
  };
}
