{ lib
, python3Packages
, libwnck
, gtk3
, libnotify
, wrapGAppsHook3
, gobject-introspection
, substituteAll
}:

python3Packages.buildPythonPackage rec {
    pname = "keep-images";
    version = "0.1.0"; # in version.txt

    src = ./src;

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
        # pycairo
        # requests
        pygobject3
    ];

    postPatch =
        let
            setup = substituteAll {
                src = ./setup.py;
                desc = "open a view to select which images to keep";
                inherit pname version;
            };
        in ''ln -s ${setup} setup.py'';
}

