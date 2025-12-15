{
  lib,
  python3Packages,
  libwnck,
  gtk3,
  libnotify,
  wrapGAppsHook3,
  gobject-introspection,
  replaceVars,
}:

python3Packages.buildPythonPackage rec {
  pname = "shadowbox";
  version = "0.1.0"; # in version.txt
  pyproject = true;

  src = ./src;

  build-system = [ python3Packages.setuptools ];

  buildInputs = [
    libwnck
    gtk3
    libnotify
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  propagatedBuildInputs = with python3Packages; [
    pycairo
    requests
    pygobject3
  ];

  postPatch =
    let
      setup = replaceVars ./setup.py {
        desc = "Highlight a rectangle on the screen";
        inherit pname version;
      };
    in
    ''ln -s ${setup} setup.py'';
}
