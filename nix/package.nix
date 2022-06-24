{
  stdenvNoCC,
  license_icon,
  resume,
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

  inherit license_icon resume;

  buildInputs = [go-task hugo docutils];

  buildPhase = ''
    task build
  '';

  installPhase = ''
    cp -R blog/public $out
  '';
}
