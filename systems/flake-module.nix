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
    path = ./.;

    perClass = class: {
      modules = concatLists [
        [
          self."${class}Modules".nixfiles
        ]

        (optionals (class != "iso") [
          "${self}/homes"
        ])
      ];
    };
  };
}
