{stdenv}:
stdenv.mkDerivation {
  name = "blog";
  src = builtins.path {
    path = ../.;
    name = "source";
  };
}
