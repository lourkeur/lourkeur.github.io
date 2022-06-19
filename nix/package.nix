{
  stdenvNoCC,
  hugo,
}:
stdenvNoCC.mkDerivation {
  name = "blog";
  src = builtins.path {
    path = ../blog;
    name = "source";
  };

  buildInputs = [hugo];

  buildPhase = ''
    hugo
  '';

  installPhase = ''
    cp -R public $out
  '';
}
