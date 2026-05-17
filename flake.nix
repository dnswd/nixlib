{
  description = "halcyonage/dnswd's personal nix helper library i accumulated over years that I forgot where I got it from (i forgot who to credit)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
    in
    {
      mkLib =
        {
          inputs,
          lib,
          pkgs,
        }:
        import ./default.nix {
          inherit inputs lib pkgs;
        };

      lib = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./default.nix {
          inputs = self.inputs;
          inherit (nixpkgs) lib;
          inherit pkgs;
        }
      );
    };
}
