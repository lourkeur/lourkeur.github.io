# The flake file is the entry point for nix commands
{
  description = "My blog";

  # Inputs are how Nix can use code from outside the flake during evaluation.
  inputs.fup.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.3.1";
  inputs.flake-compat.url = "github:edolstra/flake-compat";
  inputs.flake-compat.flake = false;
  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";

  inputs.resume.url = "/home/louis/perso/resume";

  # Outputs are the public-facing interface to the flake.
  outputs = inputs @ {
    self,
    fup,
    ...
  }:
    fup.lib.mkFlake {
      inherit self inputs;

      outputsBuilder = channels: with channels.nixpkgs; {
        packages.default = callPackage nix/package.nix {
          resume = inputs.resume.packages.${system}.default;
          license_icon = fetchurl {
            url = "https://i.creativecommons.org/l/by-nd/4.0/80x15.png";
            sha256 = "16c63br97qzxvcfb55g77gnxw13qpfmc0rm36818mq0825gfz68y";
          };
        };
      };
    };
}
