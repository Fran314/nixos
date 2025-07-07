let
  fetch-secret =
    { path, sha256 }:
    builtins.fetchurl {
      url = "file:///secrets/${path}";
      inherit sha256;
    };
in
{
  wireguard.latias.wg0.public = builtins.readFile (fetch-secret {
    path = "wireguard/latias/wg-vps.public";
    sha256 = "sha256:1yplc2k6ay4y1w019zhvj37a9xfv7a6g1cw0ynckm9za5b5zh5j9";
  });
}
