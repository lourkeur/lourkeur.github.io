{
  stdenvNoCC,
  go-task,
  hugo,
  docutils,
}:
stdenvNoCC.mkDerivation {
  name = "blog";
  src = builtins.path {
    path = ../.;
    name = "source";
  };

  buildInputs = [go-task hugo docutils];

  buildPhase = ''
    task build
  '';

  installPhase = ''
    cp -R blog/public $out
  '';
}
