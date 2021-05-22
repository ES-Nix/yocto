{
  description = "A usefull description";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgsAllowUnfree = import nixpkgs {
        system = "x86_64-linux";
        config = { allowUnfree = true; };
      };
    in
    {

      packages.yocto = import ./yocto.nix {
        pkgs = nixpkgs.legacyPackages.${system};
      };

      devShell = pkgsAllowUnfree.mkShell {
        buildInputs = with pkgsAllowUnfree; [
          self.yocto.${system}
        ];
      };
  });
}
