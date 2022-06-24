# The flake file is the entry point for nix commands
{
  description = "My blog";

  # Inputs are how Nix can use code from outside the flake during evaluation.
  inputs.fup.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.3.1";
  inputs.flake-compat.url = "github:edolstra/flake-compat";
  inputs.flake-compat.flake = false;
  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";

  # Outputs are the public-facing interface to the flake.
  outputs = inputs @ {
    self,
    fup,
    ...
  }:
    fup.lib.mkFlake {
      inherit self inputs;

      outputsBuilder = channels: with channels.nixpkgs; {
        packages.default = callPackage nix/package.nix { };
      };
    };
}
