{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/1b3033ebfb1e92c3166b75c7f820d066f3dd3665";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }:
      {
        packages.default = pkgs.callPackage ./default.nix (pkgs.lib.optionalAttrs (pkgs.stdenv.isDarwin) {
          stdenv = pkgs.stdenvAdapters.overrideSDK pkgs.stdenv {
            darwinMinVersion = "11.0";
            darwinSdkVersion = "11.0";
          };
          ut = pkgs.callPackage ./nix/ut.nix { stdenv = pkgs.llvmPackages_16.stdenv; };
        }) // {};
      };
    };
}
