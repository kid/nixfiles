{
  self,
  lib,
  inputs,
  ...
}:
let
  inherit (lib.lists) concatLists optionals;
in
{
  imports = [ inputs.easy-hosts.flakeModule ];

  easy-hosts = {
    autoConstruct = true;
    path = ../systems;

    perClass = class: {
      modules = concatLists [
        [
          "${self}/modules/${class}"
        ]

        (optionals (class != "iso") [
          "${self}/modules/base"
          "${self}/homes"
        ])
      ];
    };
  };
}
