let
  fetch-secret =
    { path, sha256 }:
    builtins.readFile (
      builtins.fetchurl {
        url = "file:///secrets/${path}";
        inherit sha256;
      }
    );

in
{
  ssh.latias."id_ed25519.pub" = fetch-secret {
    path = "ssh/latias/id_ed25519.pub";
    sha256 = "sha256:1bb90xpw58vygy5qhr1zcc820r74jrnkhcq5fakwfkccp21wqsyg";
  };
  wg = {
    latias."wg-home.public" = fetch-secret {
      path = "wg/latias/wg-home.public";
      sha256 = "sha256:000akj1cljy81wycdmg4av9fxf7w20mbg7yb71pni8swq64xbcdp";
    };
  };
}
