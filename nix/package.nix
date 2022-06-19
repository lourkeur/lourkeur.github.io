{
  stdenvNoCC,
  hugo,
  docutils,
}:
stdenvNoCC.mkDerivation {
  name = "blog";
  src = builtins.path {
    path = ../blog;
    name = "source";
  };

  buildInputs = [hugo docutils];

  buildPhase = ''
    hugo
  '';

  installPhase = ''
    cp -R public $out
  '';
}
