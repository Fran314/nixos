let
  fetch-secret =
    { path, sha256 }:
    builtins.fetchurl {
      url = "file:///secrets/${path}";
      inherit sha256;
    };
in
{
  ssh-pub-keys.latias = fetch-secret {
    path = "ssh-pub-keys/latias/id_ed25519.pub";
    sha256 = "sha256:1bb90xpw58vygy5qhr1zcc820r74jrnkhcq5fakwfkccp21wqsyg";
  };
}
